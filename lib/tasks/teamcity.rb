class TeamCity
  def self.progress_start(message)
    publish "progressStart", message if running?
  end

  def self.progress_finish(message)
    publish "progressFinish", message if running?
  end

  def self.running?
    ENV.include? 'TEAMCITY_PROJECT_NAME'
  end

  private
  def self.encode(string)
    string
      .gsub(/\|/, "||")
      .gsub(/'/, "|'")
      .gsub(/\r/, "|r")
      .gsub(/\n/, "|n")
      .gsub(/\u0085/, "|x")
      .gsub(/\u2028/, "|l")
      .gsub(/\u2029/, "|p")
      .gsub(/\[/, "|[")
      .gsub(/\]/, "|]")
  end

  def self.publish(type, args)
    puts "##teamcity[#{type} '#{encode args}']"
  end
end
