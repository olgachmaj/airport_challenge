require 'safety'
require 'air_traffic_controller'
require "weather"

describe Weather do
  describe '#generate' do
    it 'generates random weather' do
      weather = Weather.new
      expect(['stormy', 'sunny']).to include(weather.generate_weather)
    end
  end
end
