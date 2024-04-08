require_relative './module/instance_counter'
require_relative './module/valid'

class Station
  include InstanceCounter
  include Valid

  attr_reader :trains, :name

  STATION_NAME = /\A[А-Я][а-я]{1,15}\z/

  @@stations = []

  def initialize(name)
    @name= name
    @trains = []
    @@stations.append(self)
    register_instance
    valid!
  end

  def self.all
    @@stations
  end

  def train_take(train)
    @trains.append(train)
  end

  def train_send(train)
    @trains.delete(train)
  end

  def train_by_type
    @trains.select { |train| train.type == type }
  end
end
