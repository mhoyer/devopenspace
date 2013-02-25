# This filter can process javascript files and concatenate them into a single file.
#
# That is, it can take a single file and expend references to other files into
# the contents of those files.
#
# For javascript files there is no 'require' or 'import' statement, we
# create our own with a simple comment:
#
#   // require jquery.js
#
# ...is replaced with the contents of jquery.js.
#
# Files are looked up relative to the current file, or in the
# top-level vendor directory.
class ConcatFilter < Nanoc3::Filter
  identifier :concat
  type :text

  def run(content, args = { })
    content.gsub(%r{^\s*//\s+require\s+([/a-zA-Z0-9_\-\.]+)\s*$}) do |m|
      "// #{$1}\r\n" + load_file($1)
    end
  end

  private
  def load_file(filename)
    path = File.join(File.dirname(item[:content_filename]), filename)

    unless File.exists? path
      path = File.join(File.dirname(__FILE__), '..', '..', 'vendor', filename)
    end

    unless File.exists? path
      raise "Concat filter: Error while processing #{item[:content_filename]}. Required path not found: #{path}"
    end

    File.read(path)
  end
end

