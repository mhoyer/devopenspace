Dir["#{File.dirname(__FILE__)}/configatron/**/*.rb"].each do |path|
  require path
end
