require 'babosa'
require 'sanitize'

module Helpers
  module Items
    class Nanoc::Item
      attr_accessor :site

      def one_slash(url)
        url.gsub(%r|/{2,}|, '/')
      end

      def slug(params = {})
        base = '/'
        if params.fetch(:include_parents, true)
          base = parent.slug unless parent.nil?
        end

        here = self[:title] || identifier.split('/').last || ''

        url = base + here.gsub(%r{(/|&\w+;)}, ' ').to_slug.normalize({ :transliterate => :german }) + '/'
        one_slash url
      end

      def url(params = { })
        return @site.items.find!(self[:forward]).url(params) if self[:forward]

        if (self[:secure] || params[:secure]) && !configatron.roles.web.certificate.nil?
          return absolute_url params
        end

        base_href = configatron.roles.web.deployment.base_href
        one_slash "/#{base_href}/#{path(params)}"
      end

      def absolute_url(params = { })
        return @site.items.find!(self[:forward]).absolute_url(params) if self[:forward]

        base_href = configatron.roles.web.deployment.base_href
        path = one_slash "/#{base_href}/#{path(params)}"

        return path if configatron.env =~ /development/

        if (self[:secure] || params[:secure]) && !configatron.roles.web.certificate.nil?
          binding = configatron.roles.web.deployment.bindings.to_a.select { |b| b[:protocol] =~ /https/ }.first
        end

        binding = configatron.roles.web.deployment.bindings.to_a.first unless binding
        "#{binding[:protocol]}://#{binding[:host]}#{path}"
      end

      def teaser_blocks
        (1..10).map { |i|
          capture_for(self, "teaser_block_#{i}".to_sym)
        }.reject { |capture|
          capture.nil?
        }
      end

      def area
        area = with_parents.select { |i| i[:menu_order] }.last

        return nil unless area && area.children.any?
        area
      end

      def sidebar_image
        image_identifier = "/assets/images/articles#{identifier}"
        @site.items.find { |i| i.identifier == image_identifier }
      end

      def needs_article_title?
        self[:article] and self[:article][:title]
      end

      def needs_article_abstract?
        self[:article] and self[:article][:abstract]
      end

      def needs_sidebar?
        self[:training] or self[:trainer] or (self[:article] and self[:article][:call_to_action]) or sidebar_image or self[:quotes] or content_for self, :sidebar
      end

      def needs_additional?
        self[:quotes] or self[:trainer] or content_for self, :additional
      end

      def leads_to?(item)
        item && item.identifier =~ /^#{self.identifier}/
      end

      def is?(item)
        item.identifier == self.identifier
      end

      def with_parents
        current = self
        Enumerator.new do |yielder|
          yielder.yield current

          while current.parent
            current = current.parent
            yielder.yield current
          end
        end
      end
    end
  end
end

module Helpers
  module Links
    def i(identifier)
      @items.find! identifier
    end
  end
end
