class Station
  attr_reader :trains, :trains_type, :station_name
  def initialize(station_name)
    @station_name = station_name
    @trains = []
  end
  def train_take(train)
    @trains.append(train)
    puts "Прибыл поезд: #{train.number}"
  end
  def train_send(train)
    @trains.delete(train)
    puts "Отбывает поезд: #{train.number}"
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
    @start_station = start_station
    @end_station = end_station
    @interim_stations = []
  end
  def add_interim_stations(station)
    @interim_stations.append(station)
    puts "Добавлена промежуточная станция: #{station.station_name}"
  end
  def delete_interim_stations(station)
    @interim_stations.delete(station)
    puts "Удалена промежуточная станция: #{station.station_name}"
  end
  def print_route
    @stations = [@start_station, @interim_stations, @end_station].flatten
    @stations.each { |st| puts "#{st.station_name}"}
  end
end

class Train
  attr_reader :speed, :carriage_count, :number, :type

  TYPES = [:passenger, :cargo]
  def initialize(number, type, carriage_count)
    @number = number
    @type = TYPES[type]
    @carriage_count = carriage_count.to_i
    @speed = 0
  end
  def gain_speed(speed)
    @speed = speed
    puts "Поезд разгоняется до #{speed} км\ч"
  end
  def stop_train
    @speed = 0
    puts "Поезд остановлен"
  end
  def add_carriage
    if @speed == 0
      @carriage_count += 1
      puts "К поезду добавлен один вагон, теперь вагонов #{@carriage_count}"
    else
      puts "Невозможно добавить вагон в движении"
    end
  end
  def remove_carriage
    if @speed == 0 && @carriage_count > 0
      @carriage_count -= 1
      puts "От поезда отцеплен один вагон, осталось вагонов #{@carriage_count}"
    elsif @speed == 0 && @carriage_count == 0
      puts "Все вагоны уже отцеплены от поезда"
    else
      puts "Невозможно добавить вагон в движении"
    end
  end
  def add_rout(route)
    @route = route
    @current_station_index = 0
    current_station.train_take(self)
  end
  def move_next
    current_station.train_send(self)
    @current_station_index += 1 if @current_station_index < @route.stations.size
    current_station.train_take(self)
    puts "Отправляемся на станцию #{@route.stations[@current_station_index].station_name}"
  end
  def move_previous
    current_station.train_send(self)
    @current_station_index -= 1 if @current_station_index > 0
    current_station.train_take(self)
    puts "Отправляемся на станцию #{@route.stations[@current_station_index].station_name}"
  end
  def current_station
    @route.stations[@current_station_index]
  end
  def next_station
    @route.stations[@current_station_index + 1] if @current_station_index < @route.stations.size
  end
  def previous_station
    @route.stations[@current_station_index - 1] if @current_station_index > 0
  end
end
