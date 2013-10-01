module Figaro
  class Error < StandardError; end

  class RailsNotInitialized < Error; end
  class MissingKey < Error; end
end
