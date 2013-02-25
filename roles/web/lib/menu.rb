module Helpers
  module Navigation
    module Menu
      def menu_items_for(item_or_identifier = "/", include_self = false)
        item = item_or_identifier
        item = @site.items.find! item unless item.is_a? Nanoc::Item

        self_included = []
        self_included = [item] if include_self

        explicit_order = item.children
          .select { |i| not i[:menu_order].nil? }
          .select { |i| i[:menu_order] > 0 }
          .sort_by { |i| i[:menu_order] }

        implicit_order = item.children
          .select { |i| not i[:menu_order].nil? }
          .select { |i| i[:menu_order] <= 0 }
          .sort_by { |i| i[:title].downcase }

        self_included + explicit_order + implicit_order
      end

      def menu_tag(items, options = {}, &block)
        return unless options.fetch(:depth, 1) > 0
        return unless items
        return unless items.any?

        require_mobile = options.fetch(:mobile, Proc.new { || false })
        if require_mobile.call(items)
          haml_tag :select do
            if options[:mobile_default]
              haml_tag :option, options[:mobile_default], { :value => "" }
            end

            items.each do |item|
              attributes = { }
              attributes.merge!(yield(item, true)) if block_given?

              haml_tag :option, item[:title_for_menu] || item[:title], attributes
            end
          end
        end

        subitems = items.reject { |item| item[:hide_in_menu] }
        haml_tag :ul, { :class => "children-#{subitems.count}" } do
          subitems.each do |item|
            attributes = { }
            attributes.merge!(yield(item, false)) if block_given?

            haml_tag :li do
              haml_tag :a, item[:title_for_menu] || item[:title], attributes

              options.merge!({ :depth => options[:depth] - 1 }) if options[:depth]
              menu_tag(menu_items_for(item), options, &block)
            end
          end
        end
      end
    end
  end
end
