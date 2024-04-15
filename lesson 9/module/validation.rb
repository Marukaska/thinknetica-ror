# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end
  module ClassMethods
    def validate(name, type, *options)
      @validations ||= []
      @validations << { name: name, type: type, options: options }
    end
  end

  module InstanceMethods

    def validate!
      self.class.instance_variable_get(:@validations).each do |validation|
        value = instance_variable_get("@#{validation[:name]}")
        send("validate_#{validation[:type]}", validation[:name], value, *validation[:options])
      end
    end

    def valid?
      validate!
      true
    rescue ArgumentError
      false
    end

    private

    def validate_presence(name, value)
      raise ArgumentError, "#{name} не может быть пустым" if value.nil? || value.to_s.empty?
    end

    def validate_format(name, value, format)
      raise ArgumentError, "#{name} имеет недопустимый формат" unless value.to_s.match?(format)
    end

    def validate_type(name, value, klass)
      raise ArgumentError, "#{name} имеет неверный тип" unless value.is_a?(klass)
    end
  end
end