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
      else value
      end
    end

    def respond_to?(method, *)
      key, _ = extract_key_from_method(method)
      ENV.keys.any? { |k| k.upcase == key } || super
    end

    private

    def extract_key_from_method(method)
      method.to_s.upcase.match(/^(.+?)([\!\?]?)$/).captures
    end
  end
end
