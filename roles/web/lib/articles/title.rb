module Article
  class Title
    def initialize(item)
      @item = item
    end

    def head
      title = [] << (@item[:title] unless @item[:title_seo_overrides_title]) || ""

      title << @item[:title_seo] if @item[:title_seo]

      if @item.identifier =~ %r|^/trainings/\d| and not @item[:title_seo_overrides_title]
        title << %w(Schulung Training Seminar)
      end

      title << '-' if title.any?
      title << 'GROSSWEBER'

      title = (title.flatten.join ' ').strip
      Sanitize.clean title
    end
  end
end
