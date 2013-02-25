module Helpers
  module Redirects
    def redirects
      redirected_items = @items.select { |i| i[:redirect_from] && i[:redirect_from].size > 0 }

      redirected_items.map { |i|
        i[:redirect_from].map do |r|
          { :from => r, :to => i.url }
        end
      }.flatten
    end
  end
end
