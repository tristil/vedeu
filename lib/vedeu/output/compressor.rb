module Vedeu

  # During the conversion of a Vedeu::Char object into a string of escape
  # sequences, this class removes multiple occurences of the same escape
  # sequence, resulting in a smaller payload being sent to the renderer.
  #
  # @api private
  class Compressor

    # @param output [Array<Array<Vedeu::Char>>]
    # @return [String]
    def self.render(output)
      new(output).render
    end

    # Returns a new instance of Vedeu::Compressor.
    #
    # @param output [Array<Array<Vedeu::Char>>]
    # @return [Vedeu::Compressor]
    def initialize(output)
      @output = output
      @colour = ''
      @style  = ''
    end

    # @note Takes approximately ~70ms for 2100 chars. (2015-05-24)
    # @return [String]
    def render
      out = ''
      Array(output).flatten.each do |char|
        out << char.position.to_s
        out << colour_for(char)
        out << style_for(char)
        out << char.value
      end
      out
    end

    protected

    # @!attribute [r] output
    # @return [Array<Array<Vedeu::Char>>]
    attr_reader :output

    private

    # @param char [Vedeu::Char]
    # @return [String]
    def colour_for(char)
      return '' if char.colour == @colour

      @colour = char.colour
      @colour.to_s
    end

    # @param char [Vedeu::Char]
    # @return [String]
    def style_for(char)
      return '' if char.style == @style

      @style = char.style
      @style.to_s
    end

  end # Compressor

end # Vedeu
