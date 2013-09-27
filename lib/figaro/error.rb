module Figaro
  class Error < StandardError; end

  class RailsNotInitialized < Error; end
  class InvalidConfiguration < Error; end
end
