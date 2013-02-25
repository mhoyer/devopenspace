require 'bundler/setup' unless ENV['RUBYOPT'] =~ /bundler/ # Would fail otherwise if we run integration specs.
require 'rake/clean'
require 'configatron'
require './lib/configatron'
require './lib/tasks'

include Rake::DSL

module Build
  def self.roles
    @roles ||= Roles.new
  end

  def self.templates
    @templates ||= FileList.new("*.template").include("roles/**/*.template")
  end

  def self.config
    @config ||= {}
  end
end

namespace :role do
  RoleTask.new(Build.roles)
end

namespace :env do
  EnvTask.new do |t|
    t.environment_source = 'properties.yaml'
    t.configurer = lambda do |env_key|
      Build.config.merge!(Configuration.load_for Build.roles, env_key)
      Build.config[:env] = env_key
    end
  end

  import './lib/default_configuration.rb'
end

task :configure do
  def version_package
    "#{configatron.build.number || '1.0.0.0'}"
  end

  def absolutize_tool_paths
    tools = Build.config['tools']
    tools.each do |tool, path|
      tools[tool] = path.to_absolute if File.exists? path
    end
  end

  def add_tools_to_path
    tools = Dir.glob(File.join(File.dirname(__FILE__), 'tools/*')).join(File::PATH_SEPARATOR)
    ENV['PATH'] = tools + File::PATH_SEPARATOR + ENV['PATH']
  end

  def add_teamcity_java_runtime_to_path
    return unless ENV['TEAMCITY_JRE']

    ENV['PATH'] += ";#{ENV['TEAMCITY_JRE']}\\bin"
  end

  absolutize_tool_paths

  configatron.configure_from_hash Build.config

  add_tools_to_path
  add_teamcity_java_runtime_to_path

  CLEAN.include('deploy')
  CLEAN.include('roles/**/build')
  CLEAN.include('roles/**/deploy')
  CLEAN.include('roles/**/tmp/package')

  CLOBBER.include('tmp/')
  CLOBBER.include('roles/**/tmp')
  # Clean template results.
  CLOBBER.include(Build.templates)
  CLOBBER.map! do |f|
    next f.ext if f.pathmap('%x') == '.template'
    f
  end
end

task :configured => :configure do
  configatron.hide! :password
  configatron.safe!

  puts configatron.inspect
end

namespace :generate do
  desc 'Updates the version information for the build'
  task :version

  desc 'Updates the configuration files for the build'
  task :config do
    Build.templates.each do |template|
      QuickTemplate.exec(template, configatron)
    end
  end
end

# Public API tasks
desc 'Compiles all roles'
task :compile

desc 'Tests all roles'
task :test

desc 'Packages the build artifacts'
task :package

desc 'Deploys the build artifacts to the production system'
task :deploy do
  def collect_packages
    packages = FileList.new("roles/**/deploy/*.zip".in(File.dirname(__FILE__))).include("deploy/**/*.zip".in(File.dirname(__FILE__)))

    packages.map do |package|
      role, version = package.scan(%r|.*/(.*)-(\d.*?)\.zip$|).flatten
      destination = "roles/#{role}/tmp/deploy"

      { :zip => package, :role => role, :version => version, :destination => destination }
    end
  end

  def deploy(params = { })
    destination = {
            :computerName => configatron.deployment.connection.server,
            :username => configatron.deployment.connection.user,
            :password => configatron.deployment.connection.password
    }

    destination.merge!(params[:destination]) if params[:destination]

    MSDeploy.run \
      :tool => configatron.tools.msdeploy,
      :log_file => configatron.deployment.logfile,
      :verb => params[:verb],
      :source => params[:source],
      :dest => destination,
      :usechecksum => true,
      :allowUntrusted => true,
      :skip => params[:skip]
  end

  def package_for(role)
    collect_packages.select { |p| p[:role] == role.to_s }.first
  end

  unless configatron.deployment.connection.password
    raise "No deployment password, aborting. Set it in properties.yaml (key deployment.connection.password), or set the DEPLOY_PASSWORD environment variable."
  end

  collect_packages.each do |p|
    rm_rf p[:destination]

    SevenZip.unzip({
                           :tool => configatron.tools.zip,
                           :zip_name => p[:zip],
                           :destination => p[:destination]
                   })
  end
end
