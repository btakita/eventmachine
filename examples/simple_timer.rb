require 'rubygems'
require 'eventmachine'

EventMachine::run {
 puts "Starting the run now: #{Time.now}"
 EventMachine::add_timer 5, proc { puts "Executing timer event: #{Time.now}" }
 EventMachine::add_timer( 10 ) { puts "Executing timer event: #{Time.now}" }
}