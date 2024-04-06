require_relative '../manufacturing_company'
require_relative '../instance_counter'

class Carriage
  include ManufacturingCompany

  attr_reader :type, :number

  def initialize(number, type)
    @number = number
    @type = type
  end
end

