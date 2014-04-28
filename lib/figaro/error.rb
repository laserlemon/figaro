module Figaro
  class Error < StandardError; end

  class RailsNotInitialized < Error; end
  class MissingKey < Error; end

  class MissingKeys < Error
    def initialize(missing)
      if missing.respond_to?(:keys)
        list = missing.map{ |k,v| "- #{k}: #{v}" }.join("\n").prepend("\n")
      else
        list = missing.inspect
      end
      super("Missing required configuration keys: #{list}")
    end
  end
end
