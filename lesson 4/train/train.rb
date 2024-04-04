class Train
  attr_accessor :speed

  attr_reader :carriage, :number, :type, :route

  def initialize(number)
    @number = number
    @carriage = []
    @speed = 0
  end

  def stop_train
    @speed = 0
  end

  def add_carriage(carriage)
    @carriage << carriage  if @speed == 0
  end

  def remove_carriage(carriage)
    @carriage.delete(carriage) if @speed == 0
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
