# Prevent configatron from being reinitialized if invoked via the Rakefile.
if not defined?(configatron)
  rakefile = File.expand_path(File.dirname(__FILE__) + '/../../../rakefile')
  rakefile_default_env = File.expand_path(File.dirname(__FILE__) + '/../../../rakefile-default-env')
  Dir.chdir(File.dirname rakefile) do
    require rakefile
    require rakefile_default_env
  end
end

require 'compass'

Compass.add_project_configuration 'compass-config.rb'
