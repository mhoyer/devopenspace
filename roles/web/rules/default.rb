compile %r|.*?/web/$| do
  filter :erb
end

route %r|.*?/web/$| do
  @item.identifier.chop + '.' + @item[:extension]
end

compile %r{/(robots|sitemap|google.*)/} do
  filter :erb
end

route %r{/(robots|sitemap|google.*)/} do
  @item.identifier.chop + '.' + @item[:extension]
end

compile '/assets/css/app/' do
  filter :contextful_sass, Compass.sass_engine_options
  filter :replace, {
          :pattern => %r|url\('/content/|,
          :replacement => "url('"
  }

  filter :cache_buster
end

route %r|/assets/css/.*_.*| do
  # Don't output partials.
end

route '/assets/css/app/' do
  fp = Tempfile.open('fingerprint-all-partials') do |file|
    @items
      .select { |i| i.identifier =~ %r|^/assets/css/| }
      .each { |i| file.write i.raw_content }
    file.close

    fingerprint(file.path)
  end

  @item.identifier.chop + fp + '.css'
end

route '/assets/*/' do
  fingerprint_route_maybe_erb @item, @config[:root]
end

compile '*' do
  filter :erb

  case @item[:extension]
    when "md"
      filter :replace, {
              :pattern => /(\s)(\-\w+)/,
              :replacement => '\1<span class="nowrap">\2</span>'
      }
      filter :replace, {
              :pattern => /(\s)(Nr\.)\s+(.)/,
              :replacement => '\1\2&nbsp;\3'
      }
      filter :replace, {
              :pattern => /(\s)(§{1,2})\s+(\d)/,
              :replacement => '\1\2&nbsp;\3'
      }
      filter :kramdown
    when "haml"
      filter :erb
      filter :haml, :format => :html5, :attr_wrapper => '"'
  end

  layout 'default'

  filter :cache_buster
  filter :minify, :type => :html if configatron.roles.web.app.compress_output
end

route '/fehler/*' do
  @item.identifier.chop + '.html'
end

route '*' do
  @item.slug + 'index.html' unless @item[:forward]
end

layout '*', :haml, :format => :html5, :attr_wrapper => '"'
