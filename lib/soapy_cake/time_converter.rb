# frozen_string_literal: true

module SoapyCake
  class TimeConverter
    def initialize(time_zone)
      @zone = ActiveSupport::TimeZone.new(time_zone)
    end

    def to_cake(date)
      date = date.to_datetime if date.is_a?(Date)
      date.in_time_zone(zone).strftime('%Y-%m-%dT%H:%M:%S')
    end

    def from_cake(value)
      zone.parse(value).utc
    end

    private

    attr_reader :zone
  end
end
