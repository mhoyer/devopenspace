module Video
  class YouTubeInterview
    def initialize(metadata, index)
      @metadata = metadata
      @index = index
    end

    def anchor
      "#" + id
    end

    def id
      "interview-#{h(@metadata[:name]).kramdown_id}-#{@index}"
    end

    def embed_url
      "http://www.youtube.com/embed/#{@metadata[:youtube]}"
    end

    def iframe_title
      title.join(', ')
    end

    def iframe_url
      embed_url + "?vq=hd720&rel=0&theme=light"
    end

    def url
      "youtu.be/#{@metadata[:youtube]}"

      # youtube.com/v/ für Vollbild
    end

    def title
      ["Interview mit #{h @metadata[:name]}"] + [:youtube_info, :job_title, :source_name, :source_info].map { |item| @metadata[item] if @metadata[item] }.reject(&:nil?)
    end

    def thumbnail_url
      "http://img.youtube.com/vi/#{@metadata[:youtube]}/maxresdefault.jpg"
    end
  end
end
