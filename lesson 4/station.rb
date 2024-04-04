class Station
  attr_reader :trains, :name

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
    @trains.select { |train| train.type == type }
  end
end

