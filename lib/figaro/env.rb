module Figaro
  class Env < Hash
    def self.from(hash)
      new.replace(hash)
    end

    def method_missing(method, *)
      pair = ENV.detect { |k, _| k.upcase == method.to_s.upcase }
      pair ? pair[1] : super
    end

    def respond_to?(method, *)
      ENV.keys.any? { |k| k.upcase == method.to_s.upcase } || super
    end
  end
end
