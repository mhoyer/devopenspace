module Images
  def high_dpi(image)
    if image.respond_to? :value
      image = image.value
    end

    ext = File.extname(image)
    base_name = image.chomp(ext)

    Sass::Script::String.new(base_name + '-high-dpi' + ext, :identifier)
  end
end

module Sass::Script::Functions
  include Images

  declare :high_dpi, :args => [:identifier]
end
