require 'configatron'

class Configatron::Store
  class Hidden
    def initialize(underlying_value)
      @underlying_value = underlying_value
    end

    def inspect
      '*****'
    end

    def to_s
      @underlying_value.to_s
    end
  end

  def hide!(key)
    @_store.keys.select { |k| k.to_sym == key.to_sym }.each do |k|
      val = self.send(k)
      @_store[k] = Hidden.new(val) unless val.is_a? Enumerable
    end

    @_store.keys.each do |k|
      val = self.send(k)
      val.hide!(key) if val.class == Configatron::Store
    end
  end
end
