# frozen_string_literal: true

# handling events of calander

class Events
  require 'time'
  require 'date'
  @@event_key = 0

  private

  def initialize
    @events = Hash.new { |k, h| h[k] = {} }
  end

  def increment_key
    @@event_key += 1
  end

  def validate_date?(date)
    return true if date >= Date.today
    false
  end

  def set_date
    loop do
      puts 'format day\\month\\year: '
      date = Date.parse(gets)
      event_date = date.strftime('%d-%m-%Y')
      return [date, event_date] if validate_date?(date)

      puts 'Date must be greater than or equal to the current date'
    end
  end

  def validate_time?(time)
    return true if time.length == 3

    false
  end

  def take_time
    loop do
      puts 'in 24 hours format like h:m:s: '
      time = gets.split(':').map(&:to_i)
      return time if validate_time?(time)

      puts 'error time in 24 hours format like h:m:s: '
    end
  end

  def set_time(date, time)
    DateTime.new(date.year, date.month, date.day, time[0], time[1], time[2]).strftime('%I:%M:%S:%p')
  rescue 
    return "error"
  end

  def acquire_date
    date, event_date = set_date
    print 'enter start time '
    time = take_time
    start_time = set_time(date, time)
    loop do
      print 'enter end time ' 
      time = take_time
      end_time = set_time(date, time)
      return [event_date, start_time, end_time] if end_time > start_time

      puts 'error end time must be greater than the start time'
    end
  rescue ArgumentError => e
    puts "bad : #{e.class} - #{e.message}"
    retry
  end

  def display
    @events.each do |key, array|
      printf "Event No: #{key}-----Event Name: #{array[0]}, Date: #{array[1]}, Start Time: #{array[2]}, End Time: #{array[3]}\n\n"
    end
  end

  public

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
    @events.each do |key, array|
      puts "Event No: #{key}-----Event Name: #{array[0]}, Date: #{array[1]}, Start Time: #{array[2]}, End Time: #{array[3]}\n\n" if array[1] == date        
    end
  end

  def event_of_the_month
    puts 'enter month number: '
    mon = gets.to_i

    @events.each do |key, array|
      date = Date.parse(array[1])
      puts '***Events of the Month****'
      puts "Event No: #{key}-----Event Name: #{array[0]}, Date: #{array[1]}, Start Time: #{array[2]}, End Time: #{array[3]}\n\n" if date.month == mon
    end
  end

  def validate_month
    loop do
      puts 'Enter Month Number'
      mon = gets.chomp.to_i

      return mon if mon.between?(1, 12)

      puts 'error it has to be comprised between 1 and 12'
    end
  end

  def validate_year
    loop do
      puts 'Enter year'
      year= gets.chomp

      return year.to_i if year =~ /[1-9]\d{3}/
      puts "error invalid year"
    end
  end

  def display_month
    mon = validate_month
    year = validate_year
    start_date = Date.new(year, mon, 1)
    end_day = Date.new(year, mon, -1).strftime('%-d').to_i
    puts("#{start_date.strftime('%B, %Y')}")
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

