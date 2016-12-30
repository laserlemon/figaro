module Figaro
  module ENV
    extend self

    def required_keys!(*keys)
      missing_keys = keys.map { |key| key.upcase if send(key).to_s == '' }.compact

      unless missing_keys.size.zero?
        raise Figaro::MissingKey.new("Missing required Figaro configuration keys #{missing_keys.join(', ')}.")
      end
    end

    def respond_to?(method, *)
      key, punctuation = extract_key_from_method(method)

      case punctuation
      when "!" then has_key?(key) || super
      when "?", nil then true
      else super
      end
    end

    private

    def method_missing(method, *)
      key, punctuation = extract_key_from_method(method)

      case punctuation
      when "!" then send(key) || missing_key!(key)
      when "?" then !!send(key)
      when nil then get_value(key)
      else super
      end
    end

    def extract_key_from_method(method)
      method.to_s.downcase.match(/^(.+?)([!?=])?$/).captures
    end

    def has_key?(key)
      ::ENV.any? { |k, _| k.downcase == key }
    end

    def missing_key!(key)
      raise MissingKey.new(key)
    end

    def get_value(key)
      _, value = ::ENV.detect { |k, _| k.downcase == key }
      value
    end
  end
end
