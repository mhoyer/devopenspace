favicon = '/assets/images/favicon/'

[:default, :in_root].each do |rep|

  compile favicon, :rep => rep do
    filter :faviconize
  end

  route favicon, :rep => rep do
    if rep == :default
      @item.identifier.chop + fingerprint(@item[:filename]) + '.ico'
    else
      '/' + File.basename(@item.identifier.chop) + '.ico'
    end
  end

end

[144, 114, 72, 57].each do |dimension|
  [:apple, :in_root].each do |rep|

    rep_dim = "#{rep}_#{dimension}".to_sym
    dim = "#{dimension}x#{dimension}"

    compile favicon, :rep => rep_dim do
      filter :thumbnailize, :geometry => dim, :sharpen => false
      filter :optipng if configatron.roles.web.app.compress_output
    end

    route favicon, :rep => rep_dim do
      if rep == :apple
        File.dirname(@item.identifier) + '/apple-touch-icon-' + dim + fingerprint(@item[:filename]) + '.' + @item[:extension]
      else
        if dimension == 57
          '/apple-touch-icon.' + @item[:extension]
        else
          '/apple-touch-icon-' + dim + '.' + @item[:extension]
        end

      end
    end

  end
end
