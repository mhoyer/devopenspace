module Helpers
  module Blocks
    def block(capture)
      return nil if capture.nil?

      if capture.fetch(:metadata, []).include? :haml
        return haml_block capture[:content]
      end

      kramdown_block capture[:content]
    end

    def haml_block(content)
      return nil if content.nil?

      return ::Haml::Engine.new(content).render(self) if @haml_buffer.nil?

      ::Haml::Engine.new(content, @haml_buffer.options).render(self)
    end

    def kramdown_block(content, remove_paragraph = false, filter_as_haml = false)
      return nil if content.nil?

      if filter_as_haml
        content_splitted = content.split(/ *\r?\n */)
        html = ""

        content_splitted.each do |cs|
          text = haml_block(cs).strip
          next if text.empty?
          html << Nanoc::Filters::Kramdown.new.run(text)
        end

        return html
      end

      html = Nanoc::Filters::Kramdown.new.run(content)
      html.gsub!(/^<p>|<\/p>\s+$/, '') if remove_paragraph
      html
    end
  end
end