Dir["#{File.dirname(__FILE__)}/extensions/**/*.rb"].each do |path|
  require path
end
