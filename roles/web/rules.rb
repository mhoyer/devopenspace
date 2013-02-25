#!/usr/bin/env ruby

# A few helpful tips about the Rules file:
#
# * The order of rules is important: for each item, only the first matching
#   rule is applied.
#
# * Item identifiers start and end with a slash (e.g. "/about/" for the file
#   "content/about.html"). To select all children, grandchildren, ... of an
#   item, use the pattern "/about/*/"; "/about/*" will also select the parent,
#   because "*" matches zero or more characters.

preprocess do
  @items.each do |item|
    item.site = @site
  end
end

include_rules 'rules/favicon'
include_rules 'rules/images'
include_rules 'rules/js'
include_rules 'rules/default'
