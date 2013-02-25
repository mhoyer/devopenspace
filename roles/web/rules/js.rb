compile '/assets/js/webshim/shims/*/' do
  filter :minify, :type => :js if configatron.roles.web.app.compress_output && @item.identifier !~ /\.min/ && @item[:extension] == "js"
end

route '/assets/js/webshim/shims/*/' do
  @config[:root] + @item.identifier.chop + '.' + @item[:extension]
end

compile '/assets/js/*/' do
  filter :erb if @item[:extension] == 'erb'
  filter :concat

  filter :minify, :type => :js if configatron.roles.web.app.compress_output && @item.identifier !~ /\.min/
end

route '/assets/js/partials/*/' do
  # Don't output partials.
end

route %r{/assets/js/{app|modernizr-loader|}\.js/} do
  fp = Tempfile.open('fingerprint-all-partials') do |file|
    @items
      .select { |i| i.identifier =~ %r|^/assets/js/partials/| || i == @item }
      .each { |i| file.write i.raw_content }
    file.close

    fingerprint(file.path)
  end

  fingerprint_route_maybe_erb @item, @config[:root], fp
end

route '/assets/js/*/' do
  fingerprint_route_maybe_erb @item, @config[:root]
end
