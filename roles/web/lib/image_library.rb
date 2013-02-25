module Helpers
  module ImageLibrary
    def image(key, rep = :default)
      image_identifier = "/assets/images/library/#{key}/"
      image = @site.items.find { |i| i.identifier == image_identifier }

      return nil if image.nil?

      image.url :rep => rep
    end
  end
end
