require 'yaml'

module Helpers
  module Items
    module Tags
      @@map = YAML.load(File.open(File.join(File.dirname(__FILE__), 'item_tags.yaml')))

      def text_for(tag)
        map(tag).fetch('text', tag)
      end

      def title_for(tag)
        title = map(tag).fetch('title', nil)
        unless title
          regex_based = @@map.select{ |key, val| val['match'] }
          return tag unless regex_based.any?

          ignored, matcher = regex_based.find_all { |key, val| val['match'] =~ tag }.first
          return tag unless matcher

          title = tag.gsub matcher['match'], matcher['title']
        end
        title
      end

      private
      def map(tag)
        @@map.fetch(tag, {})
      end
    end
  end
end
