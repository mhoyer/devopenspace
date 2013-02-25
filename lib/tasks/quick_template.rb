require 'erb'

class QuickTemplate
  def self.exec(file, args)
    ensure_template file

    result_file = file.ext('')
    puts "Creating file #{result_file}"

    result = execute_erb file, args

    File.open(result_file, 'w') do
      |f| f.write(result)
    end
  end

  private
  def self.ensure_template(file)
    raise "The template file to process must be given" unless File.exist? file
  end

  def self.replace_at_sign_placeholders_with_erb_style(template)
    tag_regex = /(@\w[\w\.]+\w@)/

    hits = template.scan(tag_regex)
    tags = hits.map do |item|
      item[0].chomp('@').reverse.chomp('@').reverse.strip
    end

    tags.map! do |a|
      a.to_sym
    end
    tags.uniq!

    tags.inject(template) do |text, tag|
      text.gsub(/@#{tag.to_s}@/, "<%= #{tag.to_s} %>")
    end
  end

  def self.execute_erb(file, args)
    template = replace_at_sign_placeholders_with_erb_style File.read(file)

    erb = ERB.new(template, nil, "%")
    erb.filename = file

    erb.result binding
  end
end
