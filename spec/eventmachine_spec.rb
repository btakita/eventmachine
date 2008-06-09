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
    # are we still alive?
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

  should 'start the reactor on demand' do
    EM.should.not.reactor_running?
    EM.add_timer(0.5){}
    EM.should.reactor_running?
  end

  should '::add_timer for 0.5 seconds' do
    start = Time.now
    EM.add_timer(0.5){ wake }
    wait
    (Time.now-start).should.be.close? 0.5, 0.25
  end

  should '::add_periodic_timer that fires twice a second' do
    start, n = Time.now, 0
    timer = EM.add_periodic_timer(0.5){ n+=1; wake if n > 1 }
    wait
    EM.__send__ :cancel_timer, timer

    (Time.now-start).should.be.close? 1.0, 0.25
    n.should.be == 2
  end
end