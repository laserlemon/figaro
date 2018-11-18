# frozen_string_literal: true

require "pathname"

module Figaro
  module Utils
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
