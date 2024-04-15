# frozen_string_literal: true

require_relative '../module/manufacturing_company'
require_relative '../module/instance_counter'
require_relative '../module/validation'
require_relative '../module/acсessors'

class Train
  include ManufacturingCompany
  include InstanceCounter
  include Validation
  include Acсessors

  attr_reader :carriage, :number, :type, :route

  attr_accessor_with_history :number
  strong_attr_accessor :number, String

  validate :number, :presence
  validate :number, :format, /\A[\p{L}\d]{3}-?[\p{L}\d]{2}\z/
  validate :number, :type, String

  @@trains = {}

  def initialize(number)
    @number = number
    @carriage = []
    @speed = 0
    @@trains[number] = self
    register_instance
    validate!
  end

  def self.find(number)
    @@trains[number]
  end

  def add_carriage(carriage)
    @carriage << carriage if @speed.zero?
  end

  def remove_carriage(carriage)
    @carriage.delete(carriage) if @speed.zero?
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
    @route.stations[@current_station_index - 1] if @current_station_index.positive?
  end

  def train_carriages(&block)
    @carriage.each(&block) if block_given?
  end
end
