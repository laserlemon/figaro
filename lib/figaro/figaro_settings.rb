# for travis build issues
if !Object.const_defined?(:RUBY_ENGINE)
  RUBY_ENGINE = "ruby"
end

class FigaroSettings
  class SettingNotFoundError < StandardError; end

  class << self
    def method_missing(symbol, *args, &block)
      raise SettingNotFoundError, symbol if get_val(symbol).nil? && has_bang(symbol)
      self.class.send(:define_method, symbol) { get_val(symbol) }
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
      val = (RUBY_ENGINE == "jruby" && java.lang.System.get_property(symbol.to_s))
      val ||= (RUBY_ENGINE == "jruby" && java.lang.System.get_property(symbol.to_s.upcase))
      val ||= ENV[symbol.to_s]
      val ||= ENV[symbol.to_s.upcase]
    end
  end
end