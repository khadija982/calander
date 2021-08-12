# frozen_string_literal: true

# handling the data structure

class Model
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

  def validate_date_format(date)
    date = Date.parse(date)
    if date >= Date.today
      true
    else
      puts 'Date must be greater than equal to current date'
      false
    end
  rescue StandardError
    puts 'invalid date'
    false
  end

  def set_date(date)
    date = Date.parse(date)
    event_date = date.strftime('%d-%m-%Y')
  end

  def validate_time_format(time)
    time = time.split(':').map(&:to_i)
    if time.length == 3 && time[0].between?(0, 24) && time[1].between?(0, 60) && time[2].between?(0, 60)
      true
    else
      puts 'invalid date format'
      false
    end
  end

  def set_time(date, start_time, end_time)
    start_time = start_time.split(':').map(&:to_i)
    end_time = end_time.split(':').map(&:to_i)

    start_time = DateTime.new(date.year, date.month, date.day, start_time[0], start_time[1],
                              start_time[2]).strftime('%I:%M:%S:%p')
    end_time = DateTime.new(date.year, date.month, date.day, end_time[0], end_time[1],
                            end_time[2]).strftime('%I:%M:%S:%p')
    [start_time, end_time]
  end

  def validate_end_time(start_time, end_time)
    if end_time > start_time
      true
    else
      puts 'End time must be greater than start time'
      false
    end
  end

  def validate_mon(mon)
    mon = mon.to_i
    if !mon.between?(1, 12)
      puts 'Invalid month'
      false
    else
      true
    end
  end

  def validate_year(year)
    return true if year.chomp =~ /[1-9]\d{3}/

    puts 'error invalid year'
    false
  end

  def display
    @events.each do |key, _array|
      puts "Event No: #{key}-----Event Name: #{@events[key]['name'].chomp}, Date: #{@events[key]['date']}, Start Time: #{@events[key]['start_time']}, End Time: #{@events[key]['end_time']}\n\n"
    end
  end

  def add_event(name, date, start_time, end_time)
    flag = false
    if validate_date_format(date)
      date = set_date(date)
      if validate_time_format(start_time) && validate_time_format(end_time)
        start_time, end_time = set_time(Date.parse(date), start_time, end_time)
        if validate_end_time(start_time, end_time)
          key = increment_key
          if key > 1
            @events.merge!({ key => { 'name' => name, 'date' => date, 'start_time' => start_time,
                                      'end_time' => end_time } })
          else
            @events = { key => { 'name' => name, 'date' => date, 'start_time' => start_time, 'end_time' => end_time } }

          end
          flag = true
        end
      end
    end
    flag
  end

  def update_event(event_key, name, date, start_time, end_time)
    flag = false
    event_no = event_key.to_i
    if @events.key?(event_no)
      if validate_date_format(date)
        date = set_date(date)
        if validate_time_format(start_time) && validate_time_format(end_time)
          start_time, end_time = set_time(Date.parse(date), start_time, end_time)
          if validate_end_time(start_time, end_time)
            @events[event_no] = { 'name' => name, 'date' => date, 'start_time' => start_time, 'end_time' => end_time }
            flag = true
          end
        end
      end
    else
      puts 'Invalid Key'
      return false
    end
    flag
  end

  def remove_event(event_key)
    event_no = event_key.to_i
    if @events.delete(event_no)
      puts '***Event Removed Sucessfully****'
      true
    else
      puts 'Key not found'
      false
    end
  end

  def event_of_the_month(mon)
    if validate_mon(mon)
      mon = mon.to_i
      puts '***Events of the Month****'

      @events.each do |key, _array|
        date = Date.parse(@events[key]['date'])
        if date.month == mon
          puts "Event No: #{key}-----Event Name: #{@events[key]['name'].chomp}, Date: #{@events[key]['date']}, Start Time: #{@events[key]['start_time']}, End Time: #{@events[key]['end_time']}\n\n"
        end
      end
    end
  end

  def event_of_day(date)
    if validate_date_format(date)
      date = Date.parse(date).strftime('%d-%m-%Y')
      puts '***Events of the Day****'
      date_events = @events.select { |key, _hash| @events[key]['date'] == date }
      date_events.each do |key, _array|
        puts "Event No: #{key}-----Event Name: #{date_events[key]['name'].chomp}, Date: #{date_events[key]['date']}, Start Time: #{date_events[key]['start_time']}, End Time: #{date_events[key]['end_time']}\n\n"
      end
    end
  end

  def display_month(month, year)
    if validate_mon(month) && validate_year(year)
      year = year.chomp.to_i
      mon = month.chomp.to_i
      start_date = Date.new(year, mon, 1)
      end_day = Date.new(year, mon, -1).strftime('%-d').to_i
      puts(start_date.strftime('%B, %Y').to_s)
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
end

# frozen_string_literal: true

# controlling user the request

class Control < Model
  # def initialize
  #   @events
  # end

  def calander_view(month, year)
    display_month(month, year)
  end

  def insert_event(name, date, start_time, end_time)
    if add_event(name, date, start_time, end_time)
      puts 'event added sucessfully'
      display
    else
      puts 'event not added'
    end
  end

  def update(key, name, date, start_time, end_time)
    if update_event(key, name, date, start_time, end_time)
      puts 'event updated sucessfully'
      display
    else
      puts 'event not updated'
    end
  end

  def remove(key)
    display if remove_event(key)
  end

  def month_events(mon)
    event_of_the_month(mon)
  end

  def date_events(date)
    event_of_day(date)
  end
end

# frozen_string_literal: true

# Taking input from user

class Calander < Control
  def initialize
    @events
  end

  def menu
    loop do
      print "-------Menu--------\n"
      print " Enter 1 to Display Month\n Enter 2 to Add Event\n Enter 3 to Remove Event\n Enter 4 to Update Event\n Enter 5 to print All events of the month\n Enter 6 to print All Event of the day\n Enter 7 to Exit: "
      op = gets.to_i
      case op
      when 1
        puts 'enter month number'
        mon = gets
        puts 'enter year'
        year = gets
        calander_view(mon, year)
        
      when 2
        puts 'Enter name of the event: '
        name_event = gets
        puts 'Enter date of the event in format day\\month\\year:: '
        date = gets
        puts 'Enter start time of the event in 24 hours format like h:m:s: '
        start_time = gets
        puts 'Enter end time of the event in 24 hours format like h:m:s: '
        end_time = gets
        insert_event(name_event, date, start_time, end_time)

      when 3
        puts 'enter event key'
        key = gets
        remove(key)

      when 4
        puts 'Enter key event'
        key = gets
        puts 'Enter name of the event: '
        name_event = gets
        puts 'Enter date of the event in format day\\month\\year:: '
        date = gets
        puts 'Enter start time of the event in 24 hours format like h:m:s: '
        start_time = gets
        puts 'Enter end time of the event in 24 hours format like h:m:s: '
        end_time = gets
        update(key, name_event, date, start_time, end_time)

      when 5
        puts 'enter event no'
        mon = gets
        month_events(mon)

      when 6
        puts 'enter date'
        date = gets
        date_events(date)

      when 7
        break
      end
    end
  end
end

Calander.new.menu
