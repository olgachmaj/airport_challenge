require "safety"
require "air_traffic_controller"
require 'weather'

default_capacity = 10

describe AirTrafficController do

  describe "#land" do
    it 'Informs about plane landed if safe' do
      weather_station = double()
      allow(weather_station).to receive(:generate_weather) { "sunny" }
      controller = AirTrafficController.new(SafetyProtocol.new(default_capacity), weather_station)
      expect(controller.land('plane')).to eq ['plane']
    end

    it 'raises an error if airport is too full to land' do
      weather_station = double()
      allow(weather_station).to receive(:generate_weather) { "sunny" }
      controller = AirTrafficController.new(SafetyProtocol.new(default_capacity), weather_station)
      10.times { controller.land(Plane.new) }
      expect { controller.land('plane2') }.to raise_error 'Airport too full to land safely'
    end

    it 'raises an error if weather is unsafe to land' do
      weather_station = double()
      allow(weather_station).to receive(:generate_weather) { "stormy" }
      controller = AirTrafficController.new(SafetyProtocol.new(default_capacity), weather_station)
      expect { controller.land('plane') }.to raise_error 'Too stormy to land safely'
    end

    it 'deletes landing plane if its in the air' do
      weather_station = double()
      allow(weather_station).to receive(:generate_weather) { "sunny" }
      controller = AirTrafficController.new(SafetyProtocol.new(default_capacity), weather_station)
      controller.land('plane')
      expect { controller.land('plane') }.to raise_error 'This plane is at the airport already'
    end
  end

  describe '#land_airport_check' do
    it 'raises an error if plane is at the airport already' do
      weather_station = double()
      allow(weather_station).to receive(:generate_weather) { "sunny" }
      controller = AirTrafficController.new(SafetyProtocol.new(default_capacity), weather_station)
      controller.land('plane')
      expect { controller.land('plane') }.to raise_error 'This plane is at the airport already'
    end
  end

  describe '#take_off_airport_check' do
    it 'raises an error if plane is not at the airport' do
      weather_station = double()
      allow(weather_station).to receive(:generate_weather) { "sunny" }
      controller = AirTrafficController.new(SafetyProtocol.new(default_capacity), weather_station)
      expect { controller.take_off_airport_check('plane') }.to raise_error 'This plane is not in this airport'
    end

    it 'raises an error if plane is currently flying' do
      weather_station = double()
      allow(weather_station).to receive(:generate_weather) { "sunny" }
      controller = AirTrafficController.new(SafetyProtocol.new(default_capacity), weather_station, [], ['plane'])
      expect { controller.take_off_airport_check('plane') }.to raise_error 'This plane is currently flying'
    end
  end

  describe "#take_off" do
    it 'Plane takes off and gets added to currently_flying' do
      weather_station = double()
      allow(weather_station).to receive(:generate_weather) { "sunny" }
      controller = AirTrafficController.new(SafetyProtocol.new(default_capacity), weather_station)
      controller.land('plane')
      expect(controller.take_off('plane')).to eq ['plane']
    end
  end
end
