# frozen_string_literal: true

require_relative 'station'
require_relative 'route'
require_relative 'train/train'
require_relative 'train/cargo_train'
require_relative 'train/passenger_train'
require_relative 'carriage/carriage'
require_relative 'carriage/cargo_carriage'
require_relative 'carriage/passenger_carriage'

class TextInterface
  MENU = [
    { id: 1, title: 'Создать новую станцию', action: :create_station },
    { id: 2, title: 'Создать новый поезд', action: :create_train },
    { id: 3, title: 'Создание и управление маршрутом', action: :route_management },
    { id: 4, title: 'Назначить маршрут поезду', action: :route_assign },
    { id: 5, title: 'Управление вагонами поезда', action: :carriages_management },
    { id: 6, title: 'Переместить поезд на следующею станцию', action: :move_next },
    { id: 7, title: 'Вернуть поезд на предыдущею станцию', action: :move_previous },
    { id: 8, title: "Вывести список станций и поездов на станции\n", action: :stations_info },
    { id: 0, title: 'Выйти из программы', action: :exit_program }
  ].freeze

  def initialize
    @stations = []
    @trains = []
    @routes = []
    @carriages = []
    @error = "\n\e[31mОшибка:\e[0m"
    @done  = "\n\e[32mГотово:\e[0m"
    @info = "\n\e[33mПодсказка:\e[0m"
  end

  def start_program
    # seed
    loop do
      show_menu
      process(get_int_choice)
    end
  end

  # Для пользователя нужен только метод start_program, класс TextInterface не имеет подклассов
  private

  def show_menu
    puts "\nГлавное меню:"
    MENU.each do |item|
      puts "#{item[:id]}. #{item[:title]}"
    end
    print "\nВыберите необходимое действие: "
  end

  def process(choice)
    item = MENU.find { |i| i[:id] == choice }
    if item
      send(item[:action])
    elsif choice.is_a?(String)
      puts choice
    else
      puts "#{@error} действие с индексом #{choice} не найдено"
    end
  end

  def get_int_choice(index = 0)
    choice = gets.chop
    if choice !~ /^\d+$/
      "#{@error} ответ должен быть числом"

    else
      choice.to_i - index
    end
  end

  # ниже функции распределены на функциональные #method! и функции текстового интерфейса #method c обработкой исключений

  def create_station!(name)
    @stations << Station.new(name)
  end

  def create_train!(number, type)
    @trains << PassengerTrain.new(number) if type == :passenger
    @trains << CargoTrain.new(number) if type == :cargo
  end

  def create_route!(start_station, end_station)
    @routes << Route.new(start_station, end_station)
  end

  def add_station_route!(route_index, station_index)
    @routes[route_index].add_stations(@stations[station_index])
  end

  def delete_station_route!(route_index, station_index)
    @routes[route_index].delete_stations(@stations[station_index])
  end

  def route_assign!(train, route)
    train.add_rout(route)
  end

  def add_carriage!(train_index, carriage)
    @trains[train_index].add_carriage(carriage)
    @carriages.append(carriage)
  end

  def create_carriage!(number, size, type)
    case type
    when :passenger
      PassengerCarriage.new(number, size)
    when :cargo
      CargoCarriage.new(number, size)
    end
  end

  def remove_carriage!(train, carriage_index)
    train.remove_carriage(train.carriage[carriage_index])
  end

  def move_next!(train_index)
    @trains[train_index].move_next
  end

  def move_previous!(train_index)
    @trains[train_index].move_previous
  end

  def create_station
    puts "#{@info} название станции должно начинаться с заглавной буквы и содержать не более 15 символов на кириллице."
    print "\nВведите название для станции: "
    name = gets.chomp.to_s
    raise "#{@error} Введенное значение не соответствует шаблону." if name !~ /\A[А-Я][а-я]{1,15}\z/

    create_station!(name)
    puts "#{@done} станция '#{name}' создана."
  rescue StandardError => e
    puts e.message
    retry
  end

  def create_train
    puts "#{@info} допустимый формат для номера поезда три буквы или цифры в любом порядке, необязательный" \
         " дефис (может быть, а может нет) и еще 2 буквы или цифры."
    print "\nВведите номер для поезда: "
    number = gets.chomp
    raise "#{@error} Введенное значение не соответствует шаблону." if number !~ /\A[\p{L}\d]{3}-?[\p{L}\d]{2}\z/

    puts "\nУкажите тип поезда:"
    puts '1. Пассажирский'
    puts '2. Грузовой'
    print "\nВаш выбор: "
    case get_int_choice
    when 1
      type = :passenger
    when 2
      type = :cargo
    else
      raise "#{@error} Некорректно выбран тип поезда"
    end
    create_train!(number, type)
    puts "#{@done} создан поезд с номером '#{number}'"
  rescue StandardError => e
    puts e.message
    retry
  end

  def route_management
    puts <<~TEXT
      \nУкажите какое действие хотите совершить:
      1. Создать новый маршрут
      2. Добавить станцию в маршрут
      3. Удалить станцию из маршрута

      0. Вернутся в главное меню
    TEXT
    print "\nВаш выбор: "
    case get_int_choice
    when 1
      create_route
    when 2
      add_station_route
    when 3
      delete_station_route
    when 0
      nil
    else
      raise "#{@error} некорректный ввод"
    end
  rescue StandardError => e
    puts e.message
    retry
  end

  def create_route
    puts "\nДоступные станции:"
    display_stations
    print "\nВведите индекс начальной станции: "
    start_index = get_int_choice(1)
    print "\nВведите индекс конечной станции: "
    end_index = get_int_choice(1)
    start_station = @stations[start_index]
    end_station = @stations[end_index]
    create_route!(start_station, end_station)
    puts "#{@done} создан маршрут из '#{start_station.name}' в '#{end_station.name}'"
  rescue TypeError
    puts "#{@error} ответ должен быть числом."
    retry
  rescue NoMethodError
    puts "#{@error} введен некорректный индекс."
    retry
  end

  def add_station_route
    puts 'Доступные маршруты:'
    display_routes
    print "\nВведите индекс маршрута для редактирования: "
    route_index = get_int_choice(1)
    puts 'Доступные станции:'
    display_stations
    print "\nВведите индекс станции для добавления: "
    station_index = get_int_choice(1)
    add_station_route!(route_index, station_index)
    puts "#{@done} станция '#{@stations[station_index].name}' добавлена в маршрут"
  rescue TypeError
    puts "#{@error} ответ должен быть числом."
    retry
  rescue NoMethodError
    puts "#{@error} введен некорректный индекс."
    retry
  end

  def delete_station_route
    puts 'Доступные маршруты:'
    display_routes
    print "\nВведите индекс маршрута для редактирования: "
    route_index = get_int_choice(1)
    # удалять начальную и конечную станцию нельзя, определяем промежуточные
    display_delete_routes = @routes[route_index].stations[1..-2]
    if display_delete_routes.empty?
      puts "#{@error} маршрут содержит только начальную и конечную станцию, нет элементов для удаления"
      return
    end
    puts 'Доступные станции для удаления:'
    display_delete_routes.each_with_index { |stations, index| puts "#{index + 1}. #{stations.name}" }
    print "\nВведите индекс станции для удаления: "
    station_index = get_int_choice
    delete_station_route!(route_index, station_index)
    puts "#{@done} станция '#{@stations[station_index].name}' удалена из маршрута"
  rescue TypeError
    puts "#{@error} ответ должен быть числом."
    retry
  rescue NoMethodError
    puts "#{@error} введен некорректный индекс."
    retry
  end

  def route_assign
    puts "\nДоступные маршруты:"
    display_routes
    print "\nВведите индекс маршрута: "
    route_index = get_int_choice(1)
    puts 'Доступные поезда:'
    display_trains
    print "\nВведите индекс поезда для присвоения маршрута: "
    train_index = get_int_choice(1)
    train = @trains[train_index]
    route = @routes[route_index]
    route_assign!(train, route)
    puts "#{@done} поезд '#{train.number}' будет следовать по маршруту из '#{route.stations[0].name}' в '#{route.stations[-1].name}'"
  rescue TypeError
    puts "#{@error} ответ должен быть числом."
    retry
  rescue NoMethodError
    puts "#{@error} введен некорректный индекс."
    retry
  end

  def carriages_management
    puts <<~TEXT
      \nУкажите какое действие хотите совершить:
      1. Добавить вагон к поезду
      2. Отцепить вагоны от поезда
      3. Вывести список вагонов у поезда
      4. Добавить пассажира или загрузить груз

      0. Вернутся в главное меню
    TEXT
    print "\nВаш выбор: "
    case get_int_choice
    when 1
      add_carriages
    when 2
      remove_carriage
    when 3
      carriage_info
    when 4
      fill_carriage
    when 0
      nil
    else
      raise "#{@error} некорректный ввод"
    end
  rescue StandardError => e
    puts e.message
    retry
  end

  def add_carriages
    puts "\nДоступные поезда:"
    display_trains
    print "\nВведите индекс поезда для добавления вагона: "
    train_index = get_int_choice(1)
    train = @trains[train_index]
    print "\nВведите количество мест в вагоне: " if train.type == :passenger
    print "\nВведите общий объем груза доступный для погрузки в вагон: " if train.type == :cargo
    size = get_int_choice
    carriage = create_carriage!(rand(1000..3000).to_s, size, train.type)
    add_carriage!(train_index, carriage)
    puts "#{@done} к поезду '#{@trains[train_index].number}' добавлен вагон"
  rescue TypeError
    puts "#{@error} ответ должен быть числом."
    retry
  rescue NoMethodError
    puts "#{@error} введен некорректный индекс."
    retry
  end

  def remove_carriage
    puts "\nДоступные поезда:"
    display_trains
    print "\nВведите индекс поезда для удаления вагона: "
    train_index = get_int_choice(1)
    train = @trains[train_index]
    display_carriage = @trains[train_index].carriage
    if display_carriage.empty?
      puts "#{@error} данный поезд без вагонов."
      return
    end
    puts 'Доступные вагоны:'
    display_carriage.each_with_index { |carriage, index| puts "#{index + 1}. #{carriage.number}" }
    print "\nВведите индекс вагона: "
    carriage_index = get_int_choice(1)
    remove_carriage!(train, carriage_index)
    puts "#{@done} от поезда '#{train.number}' отсоединен вагон"
  rescue TypeError
    puts "#{@error} ответ должен быть числом."
    retry
  rescue NoMethodError
    puts "#{@error} введен некорректный индекс."
    retry
  end

  def fill_carriage
    puts "\nДоступные вагоны:"
    @carriages.each_with_index do |carriage, index|
      case carriage.type
      when :passenger
        size = carriage.free_seats
        type = "пассажирский, свободно мест: #{size}."
      when :cargo
        size = carriage.free_space
        type = "грузовой, свободный объем: #{size}."
      end
      puts "#{index + 1}. Вагон #{carriage.number} - #{type}"
    end
    print "\nВведите индекс вагона: "
    index_carriage = get_int_choice(1)
    case @carriages[index_carriage].type
    when :passenger
      @carriages[index_carriage].add_passenger
      puts "#{@done} в вагон '#{@carriages[index_carriage].number}' добавлен один пассажир"
    when :cargo
      puts "#{@info} данный вагон имеет общий объем #{@carriages[index_carriage].space}, " \
           "сейчас в нем свободно #{@carriages[index_carriage].free_space}"
      print "\nВведите количество груза которое для загрузки в вагона: "
      size = get_int_choice
      raise "#{@error} слишком большой объем груза, недостаточно места" if size > @carriages[index_carriage].free_space

      @carriages[index_carriage].add_cargo(size)
      puts "#{@done} в вагон '#{@carriages[index_carriage].number}' добавлен груз," \
           " осталось свободного места #{@carriages[index_carriage].free_space}"
    end
  rescue StandardError => e
    puts e.message
    retry
  end

  def move_next
    puts 'Доступные поезда:'
    display_trains
    print "\nВведите индекс поезда: "
    train_index = get_int_choice(1)
    if @trains[train_index].route.nil?
      puts "#{@error} данный поезд без маршрута"
      return
    end
    move_next!(train_index)
    puts "#{@done} поезд '#{@trains[train_index].number}' отправлен на следующею станцию"
  rescue TypeError
    puts "#{@error} ответ должен быть числом."
    retry
  rescue NoMethodError
    puts "#{@error} введен некорректный индекс."
    retry
  end

  def move_previous
    puts 'Доступные поезда:'
    display_trains
    print "\nВведите индекс поезда: "
    train_index = get_int_choice(1)
    if @trains[train_index].route.nil?
      puts "#{@error} данный поезд без маршрута"
      return
    end
    move_previous!(train_index)
    puts "#{@done} поезд '#{@trains[train_index].number}' отправлен на предыдущею станцию"
  rescue TypeError
    puts "#{@error} ответ должен быть числом."
    retry
  rescue NoMethodError
    puts "#{@error} введен некорректный индекс."
    retry
  end

  def stations_info
    @stations.each do |station|
      if station.trains.empty?
        trains_on_station = 'нет поездов'
      else
        trains_on_station = []
        station.train_on_station { |train| trains_on_station.append(train.number) }
        trains_on_station = "сейчас находятся поезда: #{trains_on_station.join(', ')}"
      end
      puts "На станции #{station.name} #{trains_on_station}"
    end
  end

  def carriage_info
    raise "#{@error} вы еще не создали вагонов." if @carriages.empty?

    puts "\nИнформация по всем вагонам:"
    index = 1
    @trains.each do |train|
      train.train_carriages do |carriage|
        case carriage.type
        when :passenger
          size = carriage.free_seats
          type = "пассажирский, свободно мест: #{size}"
        when :cargo
          size = carriage.free_space
          type = "грузовой, свободный объем: #{size}"
        end
        puts "#{index}. Вагон #{carriage.number} - #{type}, прицеплен к поезду #{train.number} "
        index += 1
      end
    end
  rescue StandardError => e
    puts e.message
  end

  def display_stations
    @stations.each_with_index { |station, index| puts "#{index + 1}. #{station.name}" }
  end

  def display_trains
    @trains.each_with_index { |train, index| puts "#{index + 1}. #{train.number}" }
  end

  def display_routes
    @routes.each_with_index do |route, index|
      puts "#{index + 1}. Из #{route.stations[0].name} в #{route.stations[-1].name}"
    end
  end

  def exit_program
    Kernel.exit
  end

  # def seed
  #   #Добавим станции:
  #   # railway_stations = ["Лунолет", "Драконь", "Чудолесь", "Звездарь", "Зазеркалье", "Цветоль", "Подполь"]
  #   # railway_stations.each { |station| @stations << Station.new(station)}
  #   #Добавим маршруты:
  #   # 4.times do @routes << Route.new(@stations[rand(0..6)], @stations[rand(0..6)]) end
  #   # #Создадим немного промежуточных станций:
  #   # 10.times do @routes[rand(0..3)].add_stations(@stations[rand(0..6)]) end
  #   #Добавим поезда:
  #   @trains << PassengerTrain.new("100-#{rand(10..99)}")
  #   @trains << CargoTrain.new("100-#{rand(10..99)}")
  #   #Каким то поездам повезет с маршрутом:
  #   #4.times do @trains[rand(0..3)].add_rout(@routes[rand(0..3)]) end
  # end
end

program = TextInterface.new
program.start_program
