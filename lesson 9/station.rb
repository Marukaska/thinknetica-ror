# frozen_string_literal: true

require_relative './module/instance_counter'
require_relative './module/validation'
require_relative './module/acсessors'

class Station
  include InstanceCounter
  include Validation
  include Acсessors

  attr_reader :trains, :name

  attr_accessor_with_history :name
  strong_attr_accessor :name, String

  validate :name, :presence
  validate :name, :format, /\A[А-Я][а-я]{1,15}\z/
  validate :name, :type, String

  @@stations = []

  def initialize(name)
    @name = name
    @trains = [1, 2, 3]
    @@stations.append(self)
    register_instance
    validate!
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

  def train_on_station(&block)
    @trains.each(&block) if block_given?
  end
end
