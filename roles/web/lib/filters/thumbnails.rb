class Thumbnailize < Nanoc::Filter
  identifier :thumbnailize
  type       :binary

  def run(filename, params={})
    args = ['convert', filename, '-quiet', '-strip', '-resize', params[:geometry].to_s]

    args << '-flop' if params.fetch(:flop, false)
    args << '-unsharp' << '1.5x1+0.4+0.0005' if params.fetch(:sharpen, true)
    args << '-colors' << '256'

    args << 'png8:' + output_filename

    system *(args)
  end
end
