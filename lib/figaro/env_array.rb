module Figaro
  module ENVArray
    module StartWith
      extend ENV
      extend ENVArray
      def self.get_value(key)
        non_figaro_env.select {|k, _| k.downcase.start_with? key}.values
      end
    end

    module EndWith
      extend ENV
      extend ENVArray
      def self.get_value(key)
        non_figaro_env.select {|k, _| k.downcase.end_with? key}.values
      end
    end

    def non_figaro_env
      ::ENV.reject {|k, _| k.start_with? Application::FIGARO_ENV_PREFIX }
    end
  end
end
