# Load the default environment configuration if no environment is passed on the command line.
if not Rake.application.options.show_tasks and
   not Rake.application.options.show_prereqs

  env_task = Rake.application.top_level_tasks.find(Proc.new { 'env:development' }) { |t| t =~ /^env:/ }

  Rake::Task[env_task].invoke
  Rake::Task[:configured].invoke
end
