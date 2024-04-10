module Valid
  def valid?
    valid!
    true
  rescue
    false
  end

  protected

  def valid!
    case self.class.name
    when /.*Train$/
      raise "Номер поезда не может быть пустым" if self.number.empty?
      raise "Неверный формат номера поезда" if self.number !~ self.class::TRAIN_NUMBER
    when "Station"
      raise "Название станции не может быть пустым" if self.name.empty?
      raise "Неверный формат названия станции" if self.name !~ self.class::STATION_NAME
    when /.*Carriage$/
      raise "Номер вагона не может быть пустым" if self.number.empty?
      raise "Неверный формат номера вагона" if self.number !~ self.class::CARRIAGE_NUMBER
    when "Route"
      raise "Начальная станция не может быть пустым полем" if self.stations[0].nil?
      raise "Конечная станция не может быть пустым полем" if self.stations[-1].nil?
    end
  end
end

