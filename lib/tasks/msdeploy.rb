class MSDeploy
  def self.run(attributes)
    tool = attributes.fetch(:tool)
    tee_tool = attributes.fetch(:tee_tool, "tee.exe".in(tool.dirname))
    logFile = attributes.fetch(:log_file, "msdeploy.log")

    attributes.reject! do |key, value|
      key == :tool || key == :log_file
    end

    switches = generate_switches(attributes)

    msdeploy = tool.to_absolute
    tee = tee_tool.to_absolute

    mkdir_p File.dirname logFile

    sh "#{msdeploy.escape} #{switches} 2>&1 | #{tee.escape} -a #{logFile}" do |ok, exit_code|
      raise "\nDeployment errors occurred. Exit code #{exit_code}." if !ok

      doc = File.open(logFile, 'r:ISO-8859-1', &:read)
      errors = doc.scan(/error|exception/i)

      if errors.any?
        raise "\nDeployment errors occurred. Please review #{logFile}."
      else
        puts "\nDeployment successful."
      end
    end
  end

  def self.generate_switches(attributes)
    switches = ""

    attributes.each do |switch, value|
      if value.kind_of? Array
        switches += value.collect { |element|
          generate_switches({ switch => element })
        }.join

        next
      end

      switches += "-#{switch}#{":#{value}" unless value.kind_of? Enumerable or value.kind_of? TrueClass or value.kind_of? FalseClass}" if value

      if value.kind_of? Enumerable
        switches += ":"
        switches += value.collect { |key, v|
          "#{key}#{"=#{v}" unless v.kind_of? TrueClass or v.kind_of? FalseClass}" if v
        }.join ","
      end

      switches += " "
    end

    switches
  end
end
