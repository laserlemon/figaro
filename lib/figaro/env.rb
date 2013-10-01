module Figaro
  module ENV
    extend self

    def respond_to?(method, *)
      key, punctuation = extract_key_from_method(method)

      case punctuation
      when "!" then ::ENV.keys.any? { |k| k.upcase == key } || super
      when "?", nil then true
      else super
      end
    end

    private

    def method_missing(method, *)
      key, punctuation = extract_key_from_method(method)
      _, value = ::ENV.detect { |k, _| k.upcase == key }

      case punctuation
      when "!" then value || missing_key!(key)
      when "?" then !!value
      when nil then value
      else super
      end
    end

    def extract_key_from_method(method)
      method.to_s.upcase.match(/^(.+?)([!?=])?$/).captures
    end

    def missing_key!(key)
      raise MissingKey.new("Missing required Figaro configuration key #{key.inspect}.")
    end
  end
end
