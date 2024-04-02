class Station
  attr_reader :trains, :trains_type, :name

  def initialize(name)
    @name= name
    @trains = []
  end

  def train_take(train)
    @trains.append(train)
  end

  def train_send(train)
    @trains.delete(train)
  end

  def train_by_type
    @trains_type = {cargo:0, passenger:0}
    @trains.each do |train|
      @trains_type[train.type] += 1
    end
  end
end

class Route
  attr_reader :stations

  def initialize(start_station, end_station)
    @stations = [start_station, end_station]
  end

  def add_interim_stations(station)
    @stations.insert(-2, station)
  end

  def delete_interim_stations(station)
    @stations.delete(station)
  end
end

class Train
  attr_accessor :speed

  attr_reader :carriage_count, :number, :type

  TYPES = [:passenger, :cargo]

  def initialize(number, type, carriage_count)
    @number = number
    @type = TYPES[type]
    @carriage_count = carriage_count.to_i
    @speed = 0
  end

  def stop_train
    @speed = 0
  end

  def add_carriage
    @carriage_count += 1 if @speed == 0
  end

  def remove_carriage
    @carriage_count -= 1 if @speed == 0 && @carriage_count > 0
  end

  def add_rout(route)
    @route = route
    @current_station_index = 0
    current_station.train_take(self)
  end

  def move_next
    current_station.train_send(self)
    @current_station_index += 1 if next_station
    current_station.train_take(self)
  end

  def move_previous
    current_station.train_send(self)
    @current_station_index -= 1 if previous_station
    current_station.train_take(self)
  end

  def current_station
    @route.stations[@current_station_index]
  end

  def next_station
    @route.stations[@current_station_index + 1]
  end

  def previous_station
    @route.stations[@current_station_index - 1] if @current_station_index > 0
  end
end

