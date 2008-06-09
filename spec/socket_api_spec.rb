require 'helper'

# simple Socket API
module EventMachine
  class Socket

    class Client < EM::Connection
      def initialize socket
        @socket = socket
      end
      attr_accessor :socket

      def connection_completed
        socket and socket.on(:connect)
      end
      
      def receive_data data
        socket and socket.on(:data, data)
      end
      
      def unbind
        socket and socket.on(:disconnect)
      end
    end

    def initialize host, port = nil
      @callbacks = {}
      @connection = EM.connect host, port, Client, self
      yield self if block_given?
    end
  
    def on type, *args, &blk
      if blk
        @callbacks[type] = blk
        self
      else
        @callbacks[type] and @callbacks[type].call(*args)
      end
    end

    def send data
      @connection.send_data data
    end

    def disconnect flush_data = true
      @connection.close_connection(flush_data)
    end

  end
end

module EchoServer
  def receive_data data
    send_data ">> #{data}"
  end
end

EM.start_server 'localhost', 8081,      EchoServer
EM.start_server '/tmp/echoserver.sock', EchoServer

describe EM::Socket do
  behaves_like 'eventmachine'

  { 'TCP' => ['localhost', 8081],
    'Unix Domain' => '/tmp/echoserver.sock'
  }.each do |type, url|
    should "connect to #{type} servers" do
      incoming = nil

      EM::Socket.new(*url) do |s|
        s.on(:connect){
          s.send 'hi there'

        }.on(:data){ |data|
          incoming = data
          s.disconnect

        }.on(:disconnect){
          wake
        }
      end

      wait
    
      incoming.should == '>> hi there'
    end
  end
end