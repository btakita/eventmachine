$:.unshift File.join(File.dirname(__FILE__), '../lib')
require 'eventmachine'

require 'rubygems'
require 'bacon'

shared 'eventmachine' do
  $bacon_thread = Thread.current
  def wait
    Thread.stop
  end
  def wake
    $bacon_thread.wakeup
  end
end