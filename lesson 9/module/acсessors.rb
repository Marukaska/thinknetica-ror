# frozen_string_literal: true

module Acсessors
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def my_attr_accessor(*names)
      names.each do |name|
        var_name = "@#{name}".to_sym
        define_method(name) { instance_variable_get(var_name)}
        define_method("#{name}=".to_sym) { |value| instance_variable_set(var_name, value) }
      end
    end

    def attr_accessor_with_history(*names)
      names.each do |name|
        var_name = "@#{name}"
        history_var_name = "@#{name}_history"

        define_method(name) { instance_variable_get(var_name) }
        define_method("#{name}=") do |value|
          instance_variable_set(var_name, value)
          instance_variable_set(history_var_name, []) unless instance_variable_defined?(history_var_name)
          instance_variable_get(history_var_name) << value
        end

        define_method("#{name}_history") { instance_variable_get(history_var_name) }
      end
    end

    def strong_attr_accessor(*names, type)
      names.each do |name|
        var_name = "@#{name}"
        define_method(name) { instance_variable_get(var_name) }
        define_method("#{name}=") do |value|
          raise ArgumentError, "Неверный тип переменной" unless value.is_a?(type)
          instance_variable_set(var_name, value)
        end
      end
    end
  end
end