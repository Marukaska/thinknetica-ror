require_relative 'instance_counter'

class Station
  include InstanceCounter

  attr_reader :trains, :name

  @@stations = []

  def initialize(name)
    @name= name
    @trains = []
    @@stations.append(self)
    register_instance
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

