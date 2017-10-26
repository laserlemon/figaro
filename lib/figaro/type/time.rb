require "time"

require "figaro/type"

module Figaro
  class Type
    class Time < Figaro::Type
      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Style/DateTime
      def load(value)
        case value
        when nil then nil
        when ::String
          # Using DateTime to parse the incoming string value is a workaround
          # for a different behavior between Ruby 2.1 and Ruby 2.2. See:
          #
          # https://byparker.com/blog/2014/ruby-2-2-0-time-parse-localtime-regression/
          #
          # Ruby 2.1 loses UTC offset information when using the Time.strptime
          # method. Ruby 2.2 preserves the given UTC offset.
          #
          # When Ruby 2.1 reaches end of life, the implementation below can be
          # replaced by:
          #
          #   ::Time.strptime(value, format)
          #
          date_time = ::DateTime.strptime(value, format)
          ::Time.new(
            date_time.year,
            date_time.month,
            date_time.day,
            date_time.hour,
            date_time.minute,
            date_time.second + date_time.second_fraction,
            date_time.offset * 24 * 60 * 60
          )
        else raise
        end
      end
      # rubocop:enable Metrics/AbcSize, Metrics/MethodLength, Style/DateTime

      def dump(value)
        case value
        when nil then nil
        when ::Time then value.strftime(format)
        else value.to_s
        end
      end

      private

      def format
        @format ||= options.fetch(:format, "%FT%T%:z")
      end
    end
  end
end

Figaro::Type.register(:time, Figaro::Type::Time)
