class ImageConverter < Nanoc::Filter
  identifier :convert
  type :binary

  def run(filename, params={ })
    args = ['convert', '-quiet', filename, '-strip', '-quantize', 'transparent', '-dither', 'None', '-colors', params[:colors].to_s, "#{params[:format]}:" + output_filename]

    system *(args)
  end
end
