class FigaroSettings
  class << self
    def method_missing(symbol, *args, &block)
      self.class.send(:define_method, symbol) { ENV[symbol.to_s] }
      send(symbol)
    end
  end
end
