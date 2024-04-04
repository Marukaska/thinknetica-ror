class Route
  attr_reader :stations

  def initialize(start_station, end_station)
    @stations = [start_station, end_station]
  end

  def add_stations(station)
    @stations.insert(-2, station)
  end

  def delete_stations(station)
    @stations.delete(station)
  end
end

