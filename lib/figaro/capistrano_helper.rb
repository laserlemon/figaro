require 'figaro'

module Figaro
  module CapistranoHelper

    # Fetch secrets from current capistrano environment
    # @param [String|Symbol] key secret key
    # @return [String] the requested secret or nil if not found
    def fetch_secret(key)
      figaro_secrets[key.to_s]
    end

    # Fetch secrets from current capistrano environment
    # @param [String|Symbol] key secret key
    # @return [String] the requested secret
    # @raise [Figaro::MissingKeys] if the requested key is not present
    def fetch_secret!(key)
      fetch_secret(key) or raise Figaro::MissingKeys.new(key)
    end

    private

    def figaro_secrets
      @figaro_secrets ||= Figaro::Application.new(environment: "#{fetch(:stage)}", path: 'config/application.yml').configuration
    end

  end
end

# Automatically include helper methods in current object (capistrano recipes are executed in context of main object)
include Figaro::CapistranoHelper
