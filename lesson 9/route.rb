# frozen_string_literal: true

require_relative './module/instance_counter'
require_relative './module/valid'

class Route
  include InstanceCounter
  include Valid

  attr_reader :stations

  def initialize(start_station, end_station)
    @stations = [start_station, end_station]
    register_instance
    valid!
  end

  def add_stations(station)
    @stations.insert(-2, station)
  end

  def delete_stations(station)
    @stations.delete(station)
  end
end
