class JPEGTran < Nanoc::Filter
  identifier :jpegtran
  type       :binary

  def run(filename, params = {})
    system 'jpegtran',  '-copy', 'none', '-optimize', filename, output_filename
 end
end