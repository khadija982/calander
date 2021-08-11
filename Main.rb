# frozen_string_literal: true

# handling events of calander
require File.expand_path('events.rb', __dir__)

class Calander 
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

Calander.new.options
