# frozen_string_literal: true

# handling the data structure

  require 'time'
  require 'date'

class Event
  @@event_key = 0


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

  def validate_month(month)
    month = month.to_i
    if !month.between?(1, 12)
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
    @events.each do |key, event|
      puts "Event No: #{key}-----Event Name: #{event['name'].chomp}, Date: #{event['date']}, Start Time: #{event['start_time']}, End Time: #{event['end_time']}\n\n"
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
          @events[key]= { 'name' => name, 'date' => date, 'start_time' => start_time, 'end_time' => end_time }
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

  def event_of_the_month(month)
    if validate_month(month)
      month = month.to_i
      puts '***Events of the Month****'

      @events.each do |key, event|
        date = Date.parse(event['date'])
        if date.month == month
          puts "Event No: #{key}-----Event Name: #{event['name'].chomp}, Date: #{event['date']}, Start Time: #{event['start_time']}, End Time: #{event['end_time']}\n\n"
        end
      end
    end
  end

  def event_of_day(date)
    if validate_date_format(date)
      date = Date.parse(date).strftime('%d-%m-%Y')
      puts '***Events of the Day****'
      date_events = @events.select { |key, event| event['date'] == date }
      date_events.each do |key, event|
        puts "Event No: #{key}-----Event Name: #{event['name'].chomp}, Date: #{event['date']}, Start Time: #{event['start_time']}, End Time: #{event['end_time']}\n\n"
      end
    end
  end

  def display_month(month, year)
    if validate_month(month) && validate_year(year)
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

class CalanderEvent
 
 @@event_obj=Event.new

  def self.calander_view(month, year)
    @@event_obj.display_month(month, year)
  end

  def self.insert_event(name, date, start_time, end_time)
    if @@event_obj.add_event(name, date, start_time, end_time)
      puts 'event added sucessfully'
      @@event_obj.display
    else
      puts 'event not added'
    end
  end

  def self.update(key, name, date, start_time, end_time)
    if @@event_obj.update_event(key, name, date, start_time, end_time)
      puts 'event updated sucessfully'
      @@event_obj.display
    else
      puts 'event not updated'
    end
  end

  def self.remove(key)
    @@event_obj.display if @@event_obj.remove_event(key)
  end

  def self.month_events(mon)
    @@event_obj.event_of_the_month(mon)
  end

  def self.date_events(date)
    @@event_obj.event_of_day(date)
  end
end

# frozen_string_literal: true

# Taking input from user

class Calander 
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
        CalanderEvent.calander_view(mon, year)
        
      when 2
        puts 'Enter name of the event: '
        name_event = gets
        puts 'Enter date of the event in format day\\month\\year:: '
        date = gets
        puts 'Enter start time of the event in 24 hours format like h:m:s: '
        start_time = gets
        puts 'Enter end time of the event in 24 hours format like h:m:s: '
        end_time = gets
        CalanderEvent.insert_event(name_event, date, start_time, end_time)

      when 3
        puts 'enter event key'
        key = gets
        CalanderEvent.remove(key)

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
        CalanderEvent.update(key, name_event, date, start_time, end_time)

      when 5
        puts 'enter event no'
        mon = gets
        CalanderEvent.month_events(mon)

      when 6
        puts 'enter date'
        date = gets
        CalanderEvent.date_events(date)

      when 7
        break
      end
    end
  end
end

obj = Calander.new.menu
