require 'configatron'

class Configatron::Store
  def safe!
    protect_all!

    self << def to_s
      name = "configatron.#{heirarchy}"
      raise "Configuration key not found: #{name}" unless @_store.has_key?(sym)
    end
  end
end

