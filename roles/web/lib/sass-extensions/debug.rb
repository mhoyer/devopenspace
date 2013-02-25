module Debugging
  def pretty
    Sass::Script::Bool.new(configatron.roles.web.app.pretty)
  end

  def env
    Sass::Script::String.new(configatron.env)
  end
end

module Sass::Script::Functions
  include Debugging
  declare :pretty, :args => []
  declare :env, :args => []
end
