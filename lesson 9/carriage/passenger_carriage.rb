# frozen_string_literal: true

require_relative 'carriage'

class PassengerCarriage < Carriage
  attr_reader :seats, :type, :free_seats

  def initialize(number, seats)
    @seats = seats
    @free_seats = seats
    @type = :passenger
    super(number)
  end

  def add_passenger
    @free_seats -= 1 if free_seats.positive?
  end

  def occupied_seats
    @seats - @free_seats
  end
end
