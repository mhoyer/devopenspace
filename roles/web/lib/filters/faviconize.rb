require 'tempfile'

class Faviconize < Nanoc::Filter
  identifier :faviconize
  type :binary

  def run(filename, params={ })
    favicons = [16, 32].map do |d|
      temp = Tempfile.new("favicon-#{d}")
      system 'convert', filename, '-resize', "#{d}x#{d}", temp.path
      temp.path
    end

    system 'convert', *(favicons), '-strip', '-colors', '256', "ico:#{output_filename}"
  end
end

