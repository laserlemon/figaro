# frozen_string_literal: true

require "pathname"

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

    def self.find_file_path(file)
      file = ::Pathname.new(file)
      directory = ::Pathname.pwd

      loop do
        path = directory.join(file)
        return path if path.file? && path.readable?
        return nil if file.absolute? || directory.root?

        directory = directory.parent
      end
    end
  end
end
