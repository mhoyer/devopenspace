module Helpers
  module UrlParser
    class ::String
      def http?
        self.start_with? 'http://'
      end
    end
  end
end
