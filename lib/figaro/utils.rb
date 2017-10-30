module Figaro
  module Utils
    def self.strip_heredoc(string)
      padding = string.scan(/^[ \t]*(?=\S)/).min
      indent = padding ? padding.size : 0
      string.gsub(/^[ \t]{#{indent}}/, "")
    end

    def self.squish(string)
      squished = string.gsub(/\A[[:space:]]+/, "")
      squished.gsub!(/[[:space:]]+\z/, "")
      squished.gsub!(/[[:space:]]+/, " ")
      squished
    end
  end
end
