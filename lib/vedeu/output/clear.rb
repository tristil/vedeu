module Vedeu

  # Clears the area defined by an interface.
  #
  # @api private
  class Clear

    extend Forwardable

    def_delegators :border,
                   :bx,
                   :by

    def_delegators :geometry,
                   :x,
                   :y

    def_delegators :interface,
                   :colour,
                   :name,
                   :style,
                   :visible?

    class << self

      # @param group [String]
      # @return [void]
      def by_group(group = nil)
        return unless group

        Vedeu.groups.find(group).members.each { |name| clear(name) }
      end

      # @param name [String]
      # @return [void]
      def by_name(name = nil)
        return Vedeu::Terminal.clear unless name

        clear(Vedeu.interfaces.by_name(name),
              clear_border: true,
              use_terminal_colours: true)
      end

      # Clears the area defined by the interface.
      #
      # @return [Array|String]
      # @see #initialize
      def clear(interface, options = {})
        if interface.visible?
          new(interface, options).write

        else
          []

        end
      end
      alias_method :render, :clear

    end

    # Return a new instance of Vedeu::Clear.
    #
    # @param interface [Interface]
    # @param options [Hash]
    # @option options clear_border [Boolean] see {#clear_border?}
    # @option options use_terminal_colours [Boolean] see
    #   {#use_terminal_colours?}
    # @return [Vedeu::Clear]
    def initialize(interface, options = {})
      @interface = interface
      @options   = options
    end

    # For each visible line of the interface, set the foreground and background
    # colours to those specified when the interface was defined, then starting
    # write space characters over the area which the interface occupies.
    #
    # @return [Array<Array<Vedeu::Char>>]
    def clear
      if visible?
        Vedeu.timer("Clearing: #{name}") do
          y, x = *position

          @clear ||= Array.new(height) do |iy|
            Array.new(width) do |ix|
              Vedeu::Char.new(value:    ' ',
                              colour:   clear_colour,
                              style:    style,
                              position: Vedeu::Position[y + iy, x + ix])
            end
          end
        end
      else
        []

      end
    end
    alias_method :render, :clear
    alias_method :rendered, :clear

    # Clear the view and send to the terminal.
    #
    # @return [Array]
    def write
      Vedeu::Output.render(rendered)
    end

    protected

    # @!attribute [r] interface
    # @return [Interface]
    attr_reader :interface

    private

    # @see Vedeu::Borders#by_name
    def border
      @border ||= Vedeu.borders.by_name(name)
    end

    # @return [Boolean] Indicates whether the area occupied by the border of the
    #   interface should be cleared also.
    def clear_border?
      options[:clear_border]
    end

    # @return [Vedeu::Colour] The default background and foreground colours for
    #   the terminal, or the colours of the interface.
    def clear_colour
      @colour ||= if use_terminal_colours?
                    Vedeu::Colour.new(background: :default,
                                      foreground: :default)

                  else
                    colour

                  end
    end

    # @return [Hash<Symbol => Boolean>]
    def defaults
      {
        clear_border:         false,
        use_terminal_colours: false,
      }
    end

    # @see Vedeu::Geometries#by_name
    def geometry
      @geometry ||= Vedeu.geometries.by_name(name)
    end

    # Returns the height of the area to be cleared.
    #
    # @return [Fixnum]
    def height
      if clear_border?
        geometry.height

      else
        border.height

      end
    end

    # @return [Hash<Symbol => Boolean>]
    def options
      @_options ||= defaults.merge!(@options)
    end

    # @return [Vedeu::IndexPosition]
    def position
      @position ||= if clear_border?
                      [y, x]

                    else
                      [by, bx]

                    end
    end

    # @return [Boolean] Indicates whether the default terminal colours should be
    #   used to clear the area.
    def use_terminal_colours?
      options[:use_terminal_colours]
    end

    # Returns the width of the area to be cleared.
    #
    # @return [Fixnum]
    def width
      if clear_border?
        geometry.width

      else
        border.width

      end
    end

  end # Clear

end # Vedeu
