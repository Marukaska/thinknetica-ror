require_relative 'carriage'

class CargoCarriage < Carriage
  attr_reader :space, :type, :free_space

  def initialize(number, space)
    @space = space
    @free_space = space
    @type = :cargo
    super(number)
  end

  def add_cargo(cargo)
    @free_space -= cargo if (@free_space - cargo).positive?
  end

  def cargo_space
    @space - @free_space
  end
end
