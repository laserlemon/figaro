module Figaro
  class Error < StandardError; end

  class RailsNotInitialized < Error; end
  class InvalidYAML < Error; end
end
