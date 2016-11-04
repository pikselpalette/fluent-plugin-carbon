require 'fluent/plugin/socket_util'

module Fluent
  class CarbonInput < SocketUtil::BaseInput

    class TCPUnbufferedSocket < SocketUtil::TcpHandler

      def on_read(data)
        @buffer << data
        pos = 0

        while i = @buffer.index(@delimiter, pos)
          msg = @buffer[pos...i]
          @callback.call(msg, @addr)
          pos = i + @delimiter.length
        end
      rescue => e
        @log.error "unexpected error", :error => e, :error_class => e.class
        close
      end
    end

    Plugin.register_input('carbon', self)

    config_set_default :port, 2003
    config_param :delimiter, :string, :default => "\n" # syslog family add "\n" to each message and this seems only way to split messages in tcp stream

    def listen(callback)
      log.debug "carbon listener on #{@bind}:#{@port}"
      Coolio::TCPServer.new(@bind, @port, TCPUnbufferedSocket, log, @delimiter, callback)
    end

    private

    def on_message(msg, addr)
      key, val, time = msg.split
      if val =~ /^\d+$/
        val = val.to_i
      elsif val =~ /^\d+\.\d+$/
        val = val.to_f
      end
      record = {
        key => val,
      }
      unless time && key && val
        log.warn "pattern not match: #{msg.inspect}"
        return
      end

      Engine.emit(@tag, time.to_i, record)
    rescue => e
      log.error msg.dump, :error => e, :error_class => e.class, :host => addr[3]
      log.error_backtrace
    end
  end
end
