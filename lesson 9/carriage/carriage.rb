# frozen_string_literal: true

require_relative '../module/manufacturing_company'
require_relative '../module/instance_counter'
require_relative '../module/validation'
require_relative '../module/acсessors'

class Carriage
  include ManufacturingCompany
  include InstanceCounter
  include Validation
  include Acсessors

  attr_reader :number, :type

  attr_accessor_with_history :number
  strong_attr_accessor :number, String

  validate :number, :presence
  validate :number, :format, /^\d{4}$/
  validate :number, :type, String

  def initialize(number)
    @number = number
    register_instance
    validate!
  end
end
