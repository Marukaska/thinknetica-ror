require_relative '../module/manufacturing_company'
require_relative '../module/instance_counter'
require_relative '../module/valid'

class Train
  include ManufacturingCompany
  include InstanceCounter
  include Valid

  attr_reader :carriage, :number, :type, :route

  TRAIN_NUMBER = /\A[\p{L}\d]{3}-?[\p{L}\d]{2}\z/

  @@trains = {}

  def initialize(number)
    @number = number
    @carriage = []
    @speed = 0
    @@trains[number] = self
    register_instance
    valid!
  end

  def self.find(number)
    @@trains[number]
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