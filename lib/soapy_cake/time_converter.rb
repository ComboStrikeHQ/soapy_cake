# frozen_string_literal: true
module SoapyCake
  class TimeConverter
    def initialize(time_zone, time_offset = nil)
      if time_offset
        self.class.print_deprecation_warning

        # Etc/GMT time zones have their sign reversed
        time_zone = format('Etc/GMT%+d', -time_offset.to_i)
      end

      raise Error, 'Cake time zone missing' if time_zone.blank?
      @zone = ActiveSupport::TimeZone[time_zone]
    end

    def to_cake(date)
      date = date.to_datetime if date.is_a?(Date)
      date.in_time_zone(zone).strftime('%Y-%m-%dT%H:%M:%S')
    end

    def from_cake(value)
      zone.parse(value).utc
    end

    def self.print_deprecation_warning
      return if @deprecation_warning_printed
      @deprecation_warning_printed = true

      STDERR.puts 'SoapyCake - DEPRECATED: Please use time_zone instead of time_offset.'
    end

    private

    attr_reader :zone
  end
end
