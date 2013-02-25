class Rake::Task
  old_execute = self.instance_method(:execute)
  old_enhance = self.instance_method(:enhance)

  define_method(:execute) do |args|
    TeamCity.progress_start name

    begin
      puts "\n[#{name}]\n"
      old_execute.bind(self).call(args)
    ensure
      TeamCity.progress_finish name
    end
  end

  define_method(:enhance) do |deps, &block|
    rake_task = block

    if block
      source_file = block.source_location.first
      role_dir = source_file.dirname if source_file =~ %r|/rakefile|

      if role_dir
        rake_task = Proc.new do |args|
          Dir.chdir(role_dir) do
            puts "In: " + Dir.pwd
            block.call(args)
          end
        end
      end
    end

    old_enhance.bind(self).call(deps, &rake_task)
  end
end
