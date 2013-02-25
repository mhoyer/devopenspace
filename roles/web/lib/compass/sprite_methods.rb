require 'compass'

module Compass::SassExtensions::Sprites::SpriteMethods
  def filename
    File.join(Compass.configuration.generated_images_path, File.basename(name_and_hash))
  end
end
