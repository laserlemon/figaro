module Figaro
  class Error < StandardError; end

  class RailsNotInitialized < Error; end

  class MissingKey < Error
    def initialize(key)
      super("Missing required configuration key: #{key.inspect}")
    end
  end

  class MissingKeys < Error
    def initialize(keys)
      super("Missing required configuration keys: #{keys.inspect}")
    end
  end
end
