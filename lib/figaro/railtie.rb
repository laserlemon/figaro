require "rails"
require "yaml"

module Figaro
  class Railtie < ::Rails::Railtie
    config.before_configuration do
      ENV.update(Figaro.env) {|k,old,new| old.nil? ? new.to_s : old}

      if RUBY_ENGINE == "jruby"
        Figaro.env.each do |k,new|
            java.lang.System.set_property(k, new.to_s) if java.lang.System.get_property(k).nil? 
        end
      end
    end

    rake_tasks do
      load "figaro/tasks.rake"
    end
  end
end
