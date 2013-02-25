module Haml
  module Helpers
    def no_newline(&block)
      capture_haml(&block).gsub("\n", '')
    end
  end
end
