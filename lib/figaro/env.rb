module Figaro
  class Env < Hash
    def self.from(hash)
      new.replace(hash)
    end

    def method_missing(method, *)
      key, punctuation = extract_key_from_method(method)
      _, value = ENV.detect { |k, _| k.upcase == key }

      case punctuation
      when "!" then value || super
      when "?" then !!value
      when nil then value
      else super
      end
    end

    def respond_to?(method, *)
      key, punctuation = extract_key_from_method(method)

      case punctuation
      when "!" then ENV.keys.any? { |k| k.upcase == key } || super
      when "?", nil then true
      else super
      end
    end

    private

    def extract_key_from_method(method)
      method.to_s.upcase.match(/^(.+?)([!?=])?$/).captures
    end
  end
end
