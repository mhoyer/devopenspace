require 'hash_deep_merge'

class Extentize < Nanoc::Filter
  identifier :extend
  type       :binary

  def defaults
    { :multiples_of => { :width => 1, :height => 1 } }
  end

  def adjust(value, multiple)
    quotient, modulo = value.divmod multiple

    quotient * multiple + modulo.fdiv(multiple).ceil * multiple
  end

  def run(filename, params={})
    params = defaults.deep_merge params

    width, height = GW::ImageProperties.new(filename).size

    if width % params[:multiples_of][:width] != 0
      width = adjust width, params[:multiples_of][:width]
    end

    if height % params[:multiples_of][:height] != 0
      height = adjust height, params[:multiples_of][:height]
    end

    geometry = "#{width}x#{height}"

    args = ['convert', '-quiet', '-strip',
      '-extent', geometry,
      '-gravity', params[:gravity].to_s,
      '-fill', params[:color].to_s,
      filename, 'png:' + output_filename
      ]

    system *(args)
  end
end

module GW
  # Stolen from Compass
  class ImageProperties
    def initialize(file)
      @file = file
      @file_type = 'png'
    end

    def size
      @dimensions ||= send(:"get_size_for_#{@file_type}")
    rescue NoMethodError
      raise Sass::SyntaxError, "Unrecognized file type: #{@file_type}"
    end

  private
    def get_size_for_png
      File.open(@file, "rb") {|io| io.read}[0x10..0x18].unpack('NN')
    end

    def get_size_for_gif
      File.open(@file, "rb") {|io| io.read}[6..10].unpack('SS')
    end

    def get_size_for_jpg
      get_size_for_jpeg
    end

    def get_size_for_jpeg
      jpeg = JPEG.new(@file)
      [jpeg.width, jpeg.height]
    end
  end
end
