require 'nanoc/cachebuster'
include Nanoc::Helpers::CacheBusting

include Nanoc::Helpers::LinkTo
include Nanoc::Helpers::XMLSitemap
include Nanoc::Helpers::Rendering

include Helpers::Capturing
include Helpers::Blocks
include Helpers::RandomText
include Helpers::Links
include Helpers::Items
include Helpers::Items::Tags
include Helpers::Navigation::Menu
include Helpers::Lists
include Helpers::ImageLibrary
include Helpers::Redirects
include Helpers::UrlParser

class ::Hash
  include Helpers::StringIndexer
end
