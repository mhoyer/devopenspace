require 'rake/tasklib'

class EnvTask < Rake::TaskLib
  attr_accessor :task_dependencies, :environment_source, :configurer

  def initialize(task_dependencies = [])
    @task_dependencies = task_dependencies

    yield self if block_given?

    define_task
  end

  def define_task
    envs = Yamler.load environment_source

    envs.keys.collect do |key|
      desc "Switches the configuration to the #{key} environment"
      task key => task_dependencies do
        @configurer.call(key)
      end
    end

    self
  end
end
