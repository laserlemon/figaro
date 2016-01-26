
module Figaro
  class SinatraApp < Figaro::Application
    private

    def default_path
      File.join("config", "application.yml")
    end

    def default_environment
      ENV['RACK_ENV']
    end

  end
end
