class FigaroSettings
  class SettingNotFoundError < StandardError; end

  class << self
    def method_missing(symbol, *args, &block)
      if ENV.key?(symbol.to_s.upcase)
        self.class.send(:define_method, symbol) { ENV[symbol.to_s.upcase] }
        send(symbol)
      else
        raise SettingNotFoundError, symbol
      end
    end

    def respond_to?(symbol)
      ENV.key?(symbol.to_s.upcase)
    end
  end
end
