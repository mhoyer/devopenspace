class OptiPNG < Nanoc::Filter
  identifier :optipng
  type       :binary

  def run(filename, params = {})
    system 'optipng', '-quiet', '-o7', filename, '-out', output_filename
 end
end
