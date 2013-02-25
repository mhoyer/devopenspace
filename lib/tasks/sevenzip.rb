require 'tempfile'

class SevenZip
  def self.zip(params = {})
    tool = params.fetch(:tool).to_absolute
    args = params.fetch(:args, %w(a))
    zipName = params.fetch(:zip_name).to_absolute
    files = params.fetch(:files)

    return if files.empty?

    ensure_output_directory zipName

    with_file_list(files) do |file_list|
      sh tool, *args, zipName, "@#{file_list}"
    end
  end
  
  def self.unzip(params= {})
    tool = params.fetch(:tool).to_absolute
    args = params.fetch(:args, %w(x -y))
    zipName = params.fetch(:zip_name).to_absolute

    destination = params.fetch(:destination, '.')
    destination = destination.to_absolute.gsub("/", File::ALT_SEPARATOR || File::SEPARATOR)

    sh tool, *args, zipName, "-o#{destination}"
  end
  
  def self.ensure_output_directory(zipName)
    FileUtils.mkdir_p zipName.dirname
  end

  def self.with_file_list(files)
    files.map! do |f|
      f.escape
    end
    
    Tempfile.open('random') do |f|
      f.write files.uniq.join("\r\n")
      f.close

      sep = File::ALT_SEPARATOR || File::SEPARATOR
      filesToZip = f.path
      filesToZip = filesToZip.gsub("/", sep) if File::ALT_SEPARATOR

      yield(filesToZip) if block_given?
    end
  end
end
