# for travis build issues
if !Object.const_defined?(:RUBY_ENGINE)
  RUBY_ENGINE = "ruby"
end

class FigaroSettings
  class SettingNotFoundError < StandardError; end

  class << self
    def method_missing(symbol, *args, &block)
      val = get_val(symbol)
      if val.nil? && has_bang(symbol)
        raise SettingNotFoundError, symbol
      end
      self.class.send(:define_method, symbol) { val }
      send(symbol)
    end

    def respond_to?(symbol)
      return !get_val(symbol).nil?
    end
    
    private
    
    def get_symbol(symbol)
      symbol.to_s.chomp("!").to_sym
    end
    
    def has_bang(symbol)
      symbol != get_symbol(symbol)
    end
    
    def get_val(sym)
      symbol = get_symbol(sym)
      val = nil
      if RUBY_ENGINE == "jruby"
        val = java.lang.System.get_property(symbol.to_s)
      end
      if val.nil? && ENV.key?(symbol.to_s)
        val = ENV[symbol.to_s]
      end
      if val.nil? && ENV.key?(symbol.to_s.upcase)
        val = ENV[symbol.to_s.upcase]
      end
      val
    end
  end
end