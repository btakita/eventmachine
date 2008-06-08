require 'rubygems'
require 'bacon'
require File.join(File.dirname(__FILE__), '../lib/eventmachine')

shared 'eventmachine' do
  $bacon_thread = Thread.current
  def wait
    Thread.stop
  end
  def wake
    $bacon_thread.wakeup
  end
end