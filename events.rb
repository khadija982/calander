# frozen_string_literal: true

# handling events of calander
class Events
  require 'time'
  require 'date'
  @event_key = 0

  private

  def initialize
    @events = Hash.new { |k, h| h[k] = {} }
  end

  def increment_key
    @event_key += 1
  end

  def take_time
    loop do
      puts 'in 24 hours format like h:m:s: '
      time = gets.split(':').map(&:to_i)

      return time if time.length == 3

      puts 'error time in 24 hours format like h:m:s: '
    end
  end

  def acquire_date
    puts 'format day\\month\\year: '
    date = Date.parse(gets)
    event_date = date.strftime('%d-%m-%Y')
    print 'enter start time '
    time = take_time
    start_time = DateTime.new(date.year, date.month, date.day, time[0], time[1], time[2]).strftime('%I:%M:%S:%p')
    print 'enter end time '
    time = take_time
    end_time = DateTime.new(date.year, date.month, date.day, time[0], time[1], time[2]).strftime('%I:%M:%S:%p')
    [event_date, start_time, end_time]
  rescue ArgumentError => e
    puts "bad : #{e.class} - #{e.message}"
    retry
  end

  def display
    @events.each do |key, array|
      puts "Event No: #{key}-----Event Name: #{array[0]}, Date: #{array[1]}, Start Time: #{array[2]}, End Time: #{array[3]}"
    end
  end

  protected

  def add_event
    puts 'Enter name of the Event: '
    event_name = gets
    print 'Enter date '
    date, start_time, end_time = acquire_date
    event_key = increment_key
    @events[event_key] = [event_name.chomp, date, start_time, end_time]
    puts '***Event Added Sucessfully****'
    display
  end

  def remove_event
    puts 'Enter Event key: '
    event_no = gets.to_i
    if @events.delete(event_no)
      puts '***Event Removed Sucessfully****'
      display
    else
      puts 'Key not found'
    end   
  end

  def update_event
    puts 'enter event key: '
    event_no = gets.to_i  
    if @events.key?(event_no)
      puts 'enter updated name of the event: '
      event_name = gets.chomp
      print 'enter updated date '
      date, start_time, end_time = acquire_date

      @events[event_no] = [event_name, date, start_time, end_time]
      puts '***Event updated Sucessfully****'
      display
    else
      puts 'event not found'
    end
  end

  def event_of_day
    puts 'Enter the date to view all events in format day\\month\\year:  '
    date = Date.parse(gets).strftime('%d-%m-%Y')
    puts '***Events of the Day****'
    @events.each do |_key, array|
      display if array[1] == date
    end
  end

  def event_of_the_month
    puts 'enter month number: '
    mon = gets.to_i

    @events.each do |_key, array|
      date = Date.parse(array[1])
      puts '***Events of the Month****'
      display if date.month == mon
    end
  end

  def display_month
    mon = 1, year = 2021
    loop do
      puts 'Enter Month Number'
      mon = gets.chomp.to_i

      break if mon.between?(1, 12)

      puts 'error it has to be comprised between 1 and 12'
    end

    start_date = Date.new(year, mon, 1)
    end_day = Date.new(year, mon, -1).strftime('%-d').to_i
    puts("@start_date.strftime('%B, %Y')")
    puts("Sun\tMon\tTue\tWed\tThu\tFri\tSat")
    week_no = start_date.strftime('%w').to_i
    day = Date.new(year, mon, 1).strftime('%-d').to_i

    while day <= end_day
      days = Array.new(7, '    ')
      while week_no < 7 && day <= end_day
        days[week_no] = day.to_s
        week_no += 1
        day += 1
      end
      days.each { |x| print("#{x}\t") }
      week_no = 0
      puts
    end
  end
end

# frozen_string_literal: true
# handling events of calander
class Main < Events
  def options
    obj = Events.new
    op = 1
    loop do
   loop do
     print "-------Menu--------\n"
     print " Enter 1 to Display Month\n Enter 2 to Add Event\n Enter 3 to Remove Event\n Enter 4 to Update Event\n Enter 5 to print All events of the month\n Enter 6 to print All Event of the day\n Enter 7 to Exit: "
     op = gets.chomp.to_i

     break if op.between?(1, 7)

     puts 'error it has to be comprised between 1 and 6'
   end
   case op
   when 1
     obj.display_month
   when 2
     obj.add_event
   when 3
     obj.remove_event
   when 4
     obj.update_event
   when 5
     obj.event_of_the_month
   when 6
     obj.event_of_day
   else
     break
   end
    end
  end
end

  Main.new.options