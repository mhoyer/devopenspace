require 'kramdown'
require 'babosa'

module Kramdown
  module Converter
    class Base
      def generate_id(str)
        str.to_slug.normalize({ :transliterate => :german })
      end
    end
  end
end

class String
  def kramdown_id
    self.to_slug.normalize({ :transliterate => :german })
  end
end
