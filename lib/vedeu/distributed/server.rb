require 'drb'
require 'singleton'

module Vedeu

  module Distributed

    # A class for the server side of the DRb server/client relationship.
    #
    class Server

      $SAFE = 1 # disable `eval` and related calls on strings passed

      include Singleton

      # @param data [String|Symbol]
      # @return [void]
      def self.input(data)
        instance.input(data)
      end

      # @return [void]
      def self.output
        instance.output
      end

      # @return [void]
      def self.restart
        instance.restart
      end

      # @return [void]
      def self.shutdown
        instance.shutdown
      end

      # @return [void]
      def self.start
        instance.start
      end

      # @return [Symbol]
      def self.status
        instance.status
      end

      # @return [void]
      def self.stop
        instance.stop
      end

      # @param data [String|Symbol]
      # @return [void]
      def input(data)
        Vedeu.trigger(:_drb_input_, data)
      end
      alias_method :read, :input

      # @return [void]
      def output
        Vedeu.trigger(:_drb_retrieve_output_)
      end
      alias_method :write, :output

      # @return [Fixnum] The PID of the currently running application.
      def pid
        Process.pid
      end

      # @return [void]
      def restart
        return not_enabled unless drb?

        log('Not running') unless drb_running?

        log('Restarting')

        stop

        start
      end

      # When called will stop the DRb server and attempt to terminate the client
      # application.
      #
      # @note
      #   :_exit_ never gets triggered as when the DRb server goes away, no
      #   further methods will be called.
      #
      # @return [void]
      def shutdown
        return not_enabled unless drb?

        stop if drb_running?

        Vedeu.trigger(:_exit_)

        Terminal.restore_screen
      end

      # @return [Vedeu::Distributed::Server]
      def start
        return not_enabled unless drb?

        if drb_running?
          log('Already started')

        else
          log('Starting')

          DRb.start_service(uri, self)

          # DRb.thread.join # not convinced this is needed here
        end
      end

      # @return [Symbol]
      def status
        return not_enabled unless drb?

        if drb_running?
          log('Running')

          :running

        else
          log('Stopped')

          :stopped

        end
      end

      # @return [void]
      def stop
        return not_enabled unless drb?

        if drb_running?
          log('Stopping')

          DRb.stop_service

          DRb.thread.join

        else
          log('Already stopped')

        end
      rescue NoMethodError # raised when #join is called on NilClass.
        # ...

      end

      private

      attr_reader :configuration

      # @return [Boolean]
      def drb?
        Vedeu::Configuration.drb?
      end

      # @return [String]
      def drb_host
        Vedeu::Configuration.drb_host
      end

      # @return [|NilClass]
      def drb_running?
        DRb.thread
      end

      # @return [Fixnum|String]
      def drb_port
        Vedeu::Configuration.drb_port
      end

      # @return [void]
      def log(message)
        Vedeu.log(type: :drb, message: "#{message}: '#{uri}'")
      end

      # @return [Symbol]
      def not_enabled
        log('Not enabled')

        :drb_not_enabled
      end

      # @return [String]
      def uri
        Vedeu::Distributed::Uri.new(drb_host, drb_port).to_s
      end

    end # Server

  end # Distributed

end # Vedeu
