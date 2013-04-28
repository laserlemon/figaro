module Figaro
  class Env < Hash
    def self.from(hash)
      new.replace(hash)
    end

    def method_missing(method, *)
      ENV.fetch(method.to_s.upcase) { super }
    end

    def respond_to_missing?(*args)
      ENV.key?(args.first.to_s.upcase)
    end
  end
end
