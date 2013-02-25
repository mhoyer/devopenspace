class Array
  def find!(identifier)
    item = self.find { |i| i.identifier == identifier }
    raise "Item to link not found: #{identifier}" unless item
    item
  end
end
