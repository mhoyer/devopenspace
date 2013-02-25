require 'nanoc'
require 'nanoc/cli'
require 'rspec/core/rake_task'
require 'sass/exec'

task :configure do
  branch = configatron.build.branch
  next if branch == 'master'

  warn "Modifying build configuration for branch #{branch}"

  uri = URI.parse(configatron.roles.web.app.base_url)
  uri.host = "#{branch}.#{uri.host}"
  configatron.roles.web.app.base_url = uri.to_s

  configatron.roles.web.deployment.bindings = configatron.roles.web.deployment.bindings.map do |b|
    b[:host] = "#{branch}.#{b[:host]}"
    b
  end

  configatron.roles.web.deployment.location += "-#{branch}"
end

namespace :web do
  namespace :nanoc do
    desc 'Start nanoc watcher'
    task :watch => [:clean, 'generate:config', 'web:convert:all'] do
      Nanoc::CLI.run %w(watch)
    end

    desc 'Start nanoc webserver'
    task :view => ['generate:config'] do
      Nanoc::CLI.run %w(view)
    end

    desc "Validate the site's internal and external links"
    task :validate => ['compile:site'] do
      Nanoc::CLI.run %w(validate_links)
    end
  end

  namespace :convert do
    def sass_convert(opts)
      opts[:files].each do |file|
        next if File.directory?(file)

        input_format = File.extname(file).reverse.chop.reverse
        output_format = opts[:to]
        output_file = file.pathmap("%{#{opts[:map]}}X.#{output_format}")

        next if FileUtils::uptodate?(output_file, [file])

        verbose(false) { mkdir_p File.dirname(output_file) }
        convert_opts = ['--from', input_format, '--to', output_format, file, output_file]

        Sass::Exec::SassConvert.new(convert_opts).parse
      end
    end

    desc 'Converts vendor CSS to SASS'
    task :css do
      sass_convert :files => FileList.new('vendor/**/*.css'), :to => 'sass', :map => "^,tmp/"
    end

    task :all => [:css]
  end

  namespace :compile do
    desc 'Generates the nanoc part of the site'
    task :site => ['generate:config', 'convert:all'] do
      Nanoc::CLI.run %w(compile)
    end
  end

  namespace :test do
    task :clean do
      rm_rf 'build/spec'
      mkdir_p 'build/spec'
    end

    desc "Run all unit test examples"
    task :unit => :clean
    RSpec::Core::RakeTask.new(:unit) do |t|
      t.pattern = './roles/web/spec{,/*/**}/*_spec.rb'
      t.rspec_opts = %w(--backtrace --tag ~integration --format html --out roles/web/build/spec/rspec.html --format documentation)
      t.verbose = true
    end

    desc "Run all integration examples"
    task :integration => ['generate:config', :clean, 'compile:site']
    RSpec::Core::RakeTask.new(:integration) do |t|
      t.pattern = './roles/web/spec{,/*/**}/*_spec.rb'
      t.rspec_opts = %w(--backtrace --tag integration --format html --out roles/web/build/spec/rspec-integration.html --format documentation)
      t.verbose = true
    end
  end
end
