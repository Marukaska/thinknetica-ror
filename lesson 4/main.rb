require_relative 'station'
require_relative 'route'
require_relative 'train/train'
require_relative 'train/cargo_train'
require_relative 'train/passenger_train'
require_relative 'carriage/carriage'
require_relative 'carriage/cargo_carriage'
require_relative 'carriage/passenger_carriage'

=begin
Создать программу в файле main.rb, которая будет позволять пользователю через текстовый интерфейс делать следующее:
- Создавать станции
- Создавать поезда +
- Создавать маршруты и управлять станциями в нем (добавлять, удалять)
- Назначать маршрут поезду +
- Добавлять вагоны к поезду +
- Отцеплять вагоны от поезда +
- Перемещать поезд по маршруту вперед и назад
- Просматривать список станций и список поездов на станции
=end

class TextInterface
  def initialize
    @stations = []
    @trains = []
    @routes = []
    @carriages = []
  end

  def start_program
    # seed
    loop do
      main_menu
      choice = gets.chomp.to_i
      case choice
      when 1
        create_station
      when 2
        create_train
      when 3
        route_management
      when 4
        route_assign
      when 5
        add_carriage
      when 6
        remove_carriage
      when 7
        move_next
      when 8
        move_previous
      when 9
        stations_info
      when 0
        break
      else
        puts "\n\e[31mОшибка:\e[0m некорректный ввод, необходимо выбрать пункт 1-9"
      end

    end
  end

  #Для пользователя нужен только метод start_program, класс TextInterface не имеет подклассов
  private

  def main_menu
    puts <<~TEXT

      Главное меню:
      1. Создать новую станцию
      2. Создать новый поезд
      3. Создание и управление маршрутом
      4. Назначить маршрут поезду
      5. Добавить вагоны к поезду
      6. Отцепить вагоны от поезда
      7. Переместить поезд на следующею станцию
      8. Вернуть поезд на предыдущею станцию
      9. Вывести список станций и поездов на станции
            
      0. Выйти из программы
    TEXT
    print "\nВыберите необходимое действие: "
  end

  def create_station
    print "\nВведите название для станции: "
    name = gets.chomp.to_s
    @stations << Station.new(name)
    puts "\n\e[32mГотово:\e[0m станция '#{name}' создана"
  end

  def create_train
    print "\nВведите номер для поезда: "
    number = gets.chomp
    puts "\nУкажите тип поезда:"
    puts "1. Пассажирский"
    puts "2. Грузовой"
    print "\nВаш выбор: "
    choice = gets.chomp.to_i
    case choice
    when 1
      @trains << PassengerTrain.new(number)
    when 2
      @trains << CargoTrain.new(number)
    else
      puts "\n\e[31mОшибка:\e[0m некорректный ввод"
      return
    end
    puts "\n\e[32mГотово:\e[0m создан поезд с номером '#{number}'"
  end

  def route_management
    puts <<~TEXT
      Укажите какое действие хотите совершить:
      1. Создать новый маршрут
      2. Добавить станцию в маршрут
      3. Удалить станцию из маршрута

      0. Вернутся в главное меню
    TEXT
    print "\nВаш выбор: "
    choice = gets.chomp.to_i
    case choice
    when 1
      create_route
    when 2
      add_station_route
    when 3
      delete_station_route
    when 0
      return
    else
      puts "\n\e[31mОшибка:\e[0m некорректный ввод"
      return
    end
  end

  def create_route
    puts "Доступные станции:"
    display_stations
    print "\nВведите индекс начальной станции: "
    start_index = correct_index
    print "\nВведите индекс конечной станции: "
    end_index = correct_index
    start_station = @stations[start_index]
    end_station = @stations[end_index]
    @routes << Route.new(start_station, end_station)
    puts "\n\e[32mГотово:\e[0m создан маршрут из '#{start_station.name}' в '#{end_station.name}'"
  end

  def add_station_route
    puts "Доступные маршруты:"
    display_routes
    print "\nВведите индекс маршрута для редактирования: "
    route_index = correct_index
    puts "Доступные станции:"
    display_stations
    print "\nВведите индекс станции для добавления: "
    station_index = correct_index
    @routes[route_index].add_stations(@stations[station_index])
    puts "\n\e[32mГотово:\e[0m станция '#{@stations[station_index].name}' добавлена в маршрут"
  end

  def delete_station_route
    puts "Доступные маршруты:"
    display_routes
    print "\nВведите индекс маршрута для редактирования: "
    route_index = correct_index
    #удалять начальную и конечную станцию нельзя, определяем промежуточные
    display_delete_routes = @routes[route_index].stations[1..-2]
    if display_delete_routes.length.zero?
      puts "\n\e[31mОшибка:\e[0m маршрут содержит только начальную и конечную станцию, нет элементов для удаления"
      return
    end
    puts "Доступные станции для удаления:"
    display_delete_routes.each_with_index { |stations, index| puts "#{index+1}. #{stations.name}"}
    print "\nВведите индекс станции для удаления: "
    station_index = gets.chomp.to_i
    @routes[route_index].delete_stations(@stations[station_index])
    puts "\n\e[32mГотово:\e[0m станция '#{@stations[station_index].name}' удалена из маршрута"
  end

  def route_assign
    puts "Доступные маршруты:"
    display_routes
    print "\nВведите индекс маршрута: "
    route_index = correct_index
    puts "Доступные поезда:"
    display_trains
    print "\nВведите индекс поезда для присвоения маршрута: "
    train_index = correct_index
    train = @trains[train_index]
    route = @routes[route_index]
    train.add_rout(route)
    puts "\n\e[32mГотово:\e[0m поезд '#{train.number}' будет следовать по маршруту из '#{route.stations[0].name}' в '#{route.stations[-1].name}'"
  end

  def add_carriage
    puts "Доступные поезда:"
    display_trains
    print "\nВведите индекс поезда для добавления вагона: "
    train_index = correct_index
    train = @trains[train_index]
    carriage = create_carriage(rand(100..300), train.type)
    train.add_carriage(carriage)
    puts "\n\e[32mГотово:\e[0m к поезду '#{@trains[train_index].number}' добавлен вагон"
  end

  def create_carriage(number, type)
    case type
    when :passenger
      PassengerCarriage.new(number)
    when :cargo
      CargoCarriage.new(number)
    end
  end

  def remove_carriage
    puts "Доступные поезда:"
    display_trains
    print "\nВведите индекс поезда для удаления вагона: "
    train_index = correct_index
    train = @trains[train_index]
    display_carriage = @trains[train_index].carriage
    if display_carriage.length.zero?
      puts "\n\e[31mОшибка:\e[0m данный поезд без вагонов"
      return
    end
    puts "Доступные вагоны:"
    display_carriage.each_with_index { |carriage, index| puts "#{index+1}. #{carriage.number}"}
    print "\nВведите индекс вагона: "
    carriage_index = correct_index
    train.remove_carriage(train.carriage[carriage_index])
    puts "\n\e[32mГотово:\e[0m от поезда '#{train.number}' отсоединен вагон #{train.carriage[carriage_index]}"
  end

  def move_next
    puts "Доступные поезда:"
    display_trains
    print "\nВведите индекс поезда: "
    train_index = correct_index
    if @trains[train_index].route.nil?
      puts "\n\e[31mОшибка:\e[0m данный поезд без маршрута"
      return
    end
    @trains[train_index].move_next
    puts "\n\e[32mГотово:\e[0m поезд '#{@trains[train_index].number}' отправлен на следующею станцию"
  end

  def move_previous
    puts "Доступные поезда:"
    display_trains
    print "\nВведите индекс поезда: "
    train_index = correct_index
    if @trains[train_index].route.nil?
      puts "\n\e[31mОшибка:\e[0m данный поезд без маршрута"
      return
    end
    @trains[train_index].move_previous
    puts "\n\e[32mГотово:\e[0m поезд '#{@trains[train_index].number}' отправлен на предыдущею станцию"
  end

  def stations_info
    @stations.each do |station|
      if station.trains.size.zero?
        trains_on_station= "нет поездов"
      else
        trains_on_station = []
        station.trains.each { |train| trains_on_station.append(train.number) }
        trains_on_station = "сейчас находятся поезда: " + trains_on_station.join(", ")
      end
      puts "На станции #{station.name} #{trains_on_station}"
    end
  end

  def display_stations
    @stations.each_with_index { |station, index| puts "#{index+1}. #{station.name}"}
  end

  def display_trains
    @trains.each_with_index { |train, index| puts "#{index+1}. #{train.number}"}
  end

  def display_routes
    @routes.each_with_index { |route, index| puts "#{index+1}. Из #{route.stations[0].name} в #{route.stations[-1].name}"}
  end

  def correct_index
    #Для красивого визуального отображения пользователю все списки выводятся с 1, но правильные индексы в массивах -1
    gets.chomp.to_i - 1
  end

  # def seed
  #   #Добавим станции:
  #   railway_stations = ["Лунолет", "Драконь", "Чудолесь", "Звездарь", "Зазеркалье", "Цветоль", "Подполь"]
  #   railway_stations.each { |station| @stations << Station.new(station)}
  #   #Добавим маршруты:
  #   4.times do @routes << Route.new(@stations[rand(0..6)], @stations[rand(0..6)]) end
  #   #Создадим немного промежуточных станций:
  #   10.times do @routes[rand(0..3)].add_stations(@stations[rand(0..6)]) end
  #   #Добавим поезда:
  #   3.times do @trains << PassengerTrain.new(rand(1000..9999)) end
  #   3.times do @trains << CargoTrain.new(rand(1000..9999)) end
  #   #Каким то поездам повезет с маршрутом:
  #   4.times do @trains[rand(0..3)].add_rout(@routes[rand(0..3)]) end
  # end
end

program = TextInterface.new
program.start_program
