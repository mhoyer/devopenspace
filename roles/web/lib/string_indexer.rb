module Helpers
  module StringIndexer
    class ArrayAccessError < StandardError
    end

    class NotSupportedError < StandardError
      def initialize(klass)
        super "StringIndexer was included in #{klass}, but only supports Hash"
      end
    end

    def StringIndexer.included(instance)
      raise NotSupportedError.new(instance) unless instance == ::Hash
    end

    def attr(key)
      fetch(key, nil) || resolve_by_string(key) || default || (default_proc.call(self, key) if default_proc)
    end

    private
    def resolve_by_string(key)
      return nil unless key.is_a? String
      raise ArrayAccessError if key =~ /\[/

      key.to_s.split('.').map(&:to_sym).inject(self) { |memo, k|
        memo.fetch(k, nil) or return memo.default
      }
    end
  end
end
