def fingerprint_route_maybe_erb(item, site_root, fingerprint = nil)
  fp = fingerprint || fingerprint(item[:filename])

  case item[:extension]
    when 'erb'
      erb_file = site_root + item.identifier.chop
      without_erb = erb_file.chomp(File.extname(erb_file))
      without_erb + fp + File.extname(erb_file)
    else
      site_root + item.identifier.chop + fp + '.' + item[:extension]
    end
end
