module Helpers

  # Provides functionality for “capturing” content in one place and reusing
  # this content elsewhere.
  #
  # For example, suppose you want the sidebar of your site to contain a short
  # summary of the item. You could put the summary in the meta file, but
  # that’s not possible when the summary contains eRuby. You could also put
  # the sidebar inside the actual item, but that’s not very pretty. Instead,
  # you write the summary on the item itself, but capture it, and print it in
  # the sidebar layout.
  #
  # This helper has been tested with ERB and Haml. Other filters may not work
  # correctly.
  #
  # @example Capturing content for a summary
  #
  #   <% content_for :summary do %>
  #     <p>On this item, nanoc is introduced, blah blah.</p>
  #   <% end %>
  #
  # @example Showing captured content in a sidebar
  #
  #   <div id="sidebar">
  #     <h3>Summary</h3>
  #     <%= content_for(@item, :summary) || '(no summary)' %>
  #   </div>
  #
  # @example Adding metadata
  #
  #   <% content_for :summary, :foo, :bar do %>
  #     <p>This content has :foo and :bar as metadata.</p>
  #   <% end %>
  module Capturing

    # @api private
    class CapturesStore

      require 'singleton'
      include Singleton

      def initialize
        @store = {}
      end

      def []=(item, name, content)
        @store[item.identifier] ||= {}
        @store[item.identifier][name] = content
      end

      def [](item, name)
        @store[item.identifier] ||= {}
        @store[item.identifier][name]
      end

    end

    def content_for(*args, &block)
      if block_given? # Set content
        # Get args
        if args.size < 1
          raise ArgumentError, "expected at least 1 argument (the name " +
            "of the capture) but got #{args.size} instead"
        end
        name = args[0]
        metadata = args[1..-1]

        # Capture and store
        content = capture(&block)
        CapturesStore.instance[@item, name.to_sym] = { :content => content, :metadata => metadata }
      else # Get content
        # Get args
        if args.size != 2
          raise ArgumentError, "expected 2 arguments (the item " +
            "and the name of the capture) but got #{args.size} instead"
        end
        item = args[0]
        name = args[1]

        # Get content
        capture = capture_for item, name.to_sym
        return nil if capture.nil?
        capture.fetch(:content, nil)
      end
    end

    def capture_for(item, name)
      CapturesStore.instance[item, name.to_sym]
    end

    def metadata_for(item, name)
      capture = capture_for item, name.to_sym
      return nil if capture.nil?
      capture.fetch(:metadata, nil)
    end

    # Evaluates the given block and returns its contents. The contents of the
    # block is not outputted.
    #
    # @return [String] The captured result
    def capture(&block)
      # Get erbout so far
      erbout = eval('_erbout', block.binding)
      erbout_length = erbout.length

      # Execute block
      block.call

      # Get new piece of erbout
      erbout_addition = erbout[erbout_length..-1]

      # Remove addition
      erbout[erbout_length..-1] = ''

      # Done
      erbout_addition
    end

  end

end
