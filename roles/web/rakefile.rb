Dir.glob(File.join(File.dirname(__FILE__), 'lib/inwx/**/*.rb')).each do |f|
  require f
end

task :default => 'web:compile:site'

task :compile => 'web:compile:site'

task :test => 'web:test:unit'

task :package => [:clean, :compile] do
  package = "deploy/web-#{version_package}.zip".to_absolute

  temp_package = "tmp/package/"
  mkdir_p temp_package

  source_dir = 'build/bin'
  FileList.new() \
        .include("#{source_dir}/**/**") \
        .exclude("#{source_dir}/bin/*.xml") \
        .copy_hierarchy :source_dir => sourceDir,
                        :target_dir => "bin".in(temp_package)

  cp 'deploy.ps1', temp_package

  FileList.new("../../tools/PowerShell/**/**") \
        .copy_hierarchy :source_dir => "../../tools/PowerShell",
                        :target_dir => "tools".in(temp_package)

  FileList.new("../../tools/WebPlatformInstaller/**/**") \
        .copy_hierarchy :source_dir => "../../tools/WebPlatformInstaller",
                        :target_dir => "tools/WebPlatformInstaller".in(temp_package)

  Dir.chdir(temp_package) do
    SevenZip.zip({
                         :tool => configatron.tools.zip,
                         :zip_name => package,
                         :files => FileList.new("**/**")
                 })
  end
end

task :deploy do
  raise "No deployment source found in tmp/deploy" unless Dir.exist? 'tmp/deploy'

  INWX::INWX.new(configatron).ensure_host

  rm_f configatron.deployment.logfile

  package = package_for :web
  destination = package[:version].in(configatron.roles.web.deployment.location)

  deploy({
                 :verb => :sync,
                 :source => { :contentPath => 'tmp/deploy'.to_absolute.escape },
                 :destination => { :contentPath => destination.escape },
                 :skip => [{ :directory => "logs" }]
         })

  cmd = %w(powershell.exe -Version 3.0 -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Unrestricted -Command)
  cmd << "deploy.ps1".in(destination).backslasherize
  cmd << 'Install'
  cmd = cmd.join(" ").escape

  deploy({ :verb => :sync,
           :source => {
                   :runCommand => cmd,
                   :waitInterval => 60000
           },
           :destination => { :auto => true }
         })
end
