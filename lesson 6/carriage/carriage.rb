require_relative '../module/manufacturing_company'
require_relative '../module/instance_counter'
require_relative '../module/valid'

class Carriage
  include ManufacturingCompany
  include InstanceCounter
  include Valid

  attr_reader :type, :number

  CARRIAGE_NUMBER = /\A\d{4}\z/

  def initialize(number, type)
    @number = number
    @type = type
    register_instance
    valid!
  end
end

