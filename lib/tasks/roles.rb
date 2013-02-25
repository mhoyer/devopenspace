class Roles
  include Enumerable

  def rakefiles
    # Always import rakefile-local.rb from roles (containing private tasks, possibly a dependency of the role to be built).
    rakefiles = self.map { |role| File.join role[:path], "rakefile-local.rb" }

    # Import all roles' rakefile.rb or just role:foo's rakefile.rb.
    rakefiles << explicit_roles.map { |role| File.join role[:path], "rakefile.rb" }

    rakefiles.flatten
  end

  def global_role
    {
      :path => '.',
      :name => 'global',
      :task => nil,
      :synthetic => true
    }
  end

  def application_roles
    Dir.glob('roles/*/').map do |path|
      name = path.scan(%r|roles/(.*?)/|).flatten.first

      {
        :path => path,
        :name => name,
        :task => "role:#{name}"
      }
    end
  end

  def each
    application_roles.each do |role|
      yield role
    end
  end

  private
  def explicit_role_tasks
    Rake.application.top_level_tasks
      .map { |t| t.scan(/^role:(.*)/).flatten.first }
      .reject(&:nil?)
  end

  def explicit_roles
    return self unless explicit_role_tasks.any?
    self.select { |role| explicit_role_tasks.any? { |task| task == role[:task] } }
  end
end
