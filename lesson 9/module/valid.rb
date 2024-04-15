# frozen_string_literal: true

module Valid
  def valid?
    valid!
    true
  rescue StandardError
    false
  end

  protected

  def valid!
    case self.class.name
    when /.*Train$/
      raise 'Номер поезда не может быть пустым' if number.empty?
      raise 'Неверный формат номера поезда' if number !~ self.class::TRAIN_NUMBER
    when 'Station'
      raise 'Название станции не может быть пустым' if name.empty?
      raise 'Неверный формат названия станции' if name !~ self.class::STATION_NAME
    when /.*Carriage$/
      raise 'Номер вагона не может быть пустым' if number.empty?
      raise 'Неверный формат номера вагона' if number !~ self.class::CARRIAGE_NUMBER
    when 'Route'
      raise 'Начальная станция не может быть пустым полем' if stations[0].nil?
      raise 'Конечная станция не может быть пустым полем' if stations[-1].nil?
    end
  end
end
