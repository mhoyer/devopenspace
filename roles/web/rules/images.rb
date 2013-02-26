compile '/assets/images/headshots/*/' do
  filter :thumbnailize, :geometry => '190x190', :flop => @item[:mirror]
  filter :optipng if configatron.roles.web.app.compress_output
end

compile '/assets/images/headshots/*/', :rep => :small do
  filter :thumbnailize, :geometry => '58x58', :flop => @item[:mirror]
  filter :optipng if configatron.roles.web.app.compress_output
end

route '/assets/images/headshots/*/', :rep => :small do
  @item.identifier.chop + '-small' + fingerprint(@item[:filename]) + '.png'
end

compile '/assets/images/library/*/', :rep => :sidebar do
  filter :thumbnailize, :geometry => '100>x'
  filter :extend, :multiples_of => { :height => 24 }, :gravity => :center, :fill => :white
  filter :optipng if configatron.roles.web.app.compress_output
end

route '/assets/images/library/*/' do
  nil
end

compile '/assets/images/articles/*/', :rep => :sidebar do
  filter :thumbnailize, :geometry => '264>x'
  filter :extend, :multiples_of => { :height => 24 }, :gravity => :center, :fill => :white
  filter :optipng if configatron.roles.web.app.compress_output
end

route '/assets/images/articles/*/' do
  nil
end

route %{/assets/images/(articles|library|headshots/trainer)/.*}, :rep => :sidebar do
  @item.identifier.chop + fingerprint(@item[:filename]) + '.png'
end

compile '/assets/images/misc/amazon-kindle/' do
  filter :thumbnailize, :geometry => 'x100>'
  filter :optipng if @item[:extension] == 'png' and configatron.roles.web.app.compress_output
  filter :jpegtran if @item[:extension] =~ /jpe?g/ and configatron.roles.web.app.compress_output
end

compile '/assets/images/*/' do
  filter :optipng if @item[:extension] == 'png' and configatron.roles.web.app.compress_output
  filter :jpegtran if @item[:extension] =~ /jpe?g/ and configatron.roles.web.app.compress_output
end

route %r|/assets/images/sprites/.+/.+| do
  # Don't output sprite sources.
end
