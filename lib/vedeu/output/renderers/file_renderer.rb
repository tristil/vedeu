module Vedeu

  # Converts a grid of {Vedeu::Char} objects into a stream of escape sequences
  # and content suitable for a terminal, and writes them to a file in the /tmp
  # directory.
  #
  class FileRenderer

    # @param output [Array<Array<Vedeu::Char>>]
    # @param options [Hash]
    # @return [String]
    def self.render(output, options = {})
      new(output, options).render
    end

    # Returns a new instance of Vedeu::FileRenderer.
    #
    # @param output [Array<Array<Vedeu::Char>>]
    # @param options [Hash]
    # @return [Vedeu::FileRenderer]
    def initialize(output, options = {})
      @output  = output
      @options = options
    end

    # @return [String]
    def render
      File.open("/tmp/#{filename}", 'w') { |f| f.write(parsed) }

      parsed
    end

    private

    # @!attribute [r] output
    # @return [Array<Array<Vedeu::Char>>]
    attr_reader :output

    # @return [String]
    def filename
      if timestamp?
        "out_#{timestamp}"

      else
        'out'

      end
    end

    # @return [String]
    def parsed
      @parsed ||= Vedeu::Compressor.new(output).render
    end

    # @return [Float]
    def timestamp
      Time.now.to_f
    end

    # @return [Boolean]
    def timestamp?
      return true if options[:timestamp]

      false
    end

    # @return [Hash]
    def options
      defaults.merge!(@options)
    end

    # @return [Hash]
    def defaults
      {
        timestamp: false,
      }
    end

  end # FileRenderer

end # Vedeu