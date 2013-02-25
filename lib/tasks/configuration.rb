require 'yamler'
require 'hash_deep_merge'

class Configuration
  def self.load_for(roles, env_key)
    yaml = {}

    all_roles = [roles.global_role] + roles.to_a

    all_roles.each do |role|
      file = File.join role[:path], 'properties.yaml'
      puts "Loading settings for role '#{role[:name]}' from '#{file}' for the '#{env_key}' environment"
      config = Configuration.load_yaml file, :hash => env_key, :inherit => :default_to

      config = { "roles" => { role[:name] => config } } unless role[:synthetic]
      yaml.deep_merge! config
    end

    if File.exists? 'local-properties.yaml'
      puts "Loading local settings from 'local-properties.yaml'"
      yaml.deep_merge! Yamler.load('local-properties.yaml')
    end

    yaml
  end

  private
  def self.load_yaml(path, opts = {})
    yml = Yamler.load path

    build_inheritance_chain yml, opts[:hash].to_s, opts[:inherit].to_s unless opts[:hash].nil? or opts[:inherit].nil?
  end

  def self.build_inheritance_chain(everything, selector, inheritance_attr)
    selection = everything[selector]

    if not selection[inheritance_attr].nil?
      puts "Settings for '#{selector}' inherit '#{selection[inheritance_attr]}' via attribute '#{inheritance_attr}'"

      inherited = build_inheritance_chain everything, selection[inheritance_attr], inheritance_attr
      selection = inherited.deep_merge(selection)
      selection.delete(inheritance_attr)
    end

    selection
  end
end
