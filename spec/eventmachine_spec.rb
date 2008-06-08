require 'helper'

describe EventMachine do
  behaves_like 'eventmachine'

  should '::run with a block' do
    start = Time.now
    EM.run{
      EM.add_timer(0.5){ EM.stop }
    }
    (Time.now-start).should.be.close? 0.5, 0.25
  end

  should 'allow nesting EM.run' do
    EM.run{
      EM.run{
        EM.add_timer(0.5){ EM.stop }
        EM.run
      }
    }
    true.should == true
  end

  should '::start in the background' do
    EM.should.not.reactor_running?
    EM.start
    EM.should.reactor_running?
  end

  should '::stop the reactor' do
    EM.should.reactor_running?
    EM.stop
    sleep 0.5
    EM.should.not.reactor_running?
  end
end