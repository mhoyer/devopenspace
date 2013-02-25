require 'rake/tasklib'

class RoleTask < Rake::TaskLib
  attr_accessor :task_dependencies, :roles

  def initialize(roles, task_dependencies = [])
    @roles = roles
    @task_dependencies = task_dependencies

    yield self if block_given?

    define_task
  end

  def define_task
    @roles.each do |role|
      desc "Limits the build to the #{role[:name]} role"
      task role[:name]
    end

    import(*@roles.rakefiles)

    self
  end
end
