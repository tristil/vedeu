module Vedeu

  module DSL

    # Provide DSL methods for configuring the geometry of an interface.
    #
    # Geometry for Vedeu, as the same for ANSI terminals, has the origin at
    # top-left, y = 1, x = 1. The 'y' coordinate is deliberately first.
    #
    # @example
    #
    #   Vedeu.geometry 'some_interface' do
    #     # ...
    #   end
    #
    #   This crude ASCII diagram represents a Geometry within Vedeu, each of the
    #   labels is a value you can access or define.
    #
    #        x    north    xn           # north:  y - 1
    #      y +--------------+           # top:    y
    #        |     top      |           # west:   x - 1
    #        |              |           # left:   x
    #   west | left   right | east      # right:  xn
    #        |              |           # east:   xn + 1
    #        |    bottom    |           # bottom: yn
    #     yn +--------------+           # south:  yn + 1
    #             south
    #
    # @api public
    class Geometry

      include Vedeu::DSL
      include Vedeu::DSL::Use

      # Specify the geometry of an interface or view with a simple DSL.
      #
      # @example
      #   Vedeu.geometry 'some_interface' do
      #     # ...
      #   end
      #
      # @param name [String] The name of the interface or view to which this
      #   geometry belongs.
      # @param block [Proc]
      # @raise [InvalidSyntax] The required block was not given.
      # @return [Vedeu::Geometry]
      def self.geometry(name, &block)
        fail InvalidSyntax, 'block not given' unless block_given?

        Vedeu::Geometry.build({ name: name }, &block).store
      end

      # Returns an instance of DSL::Geometry.
      #
      # @param model [Geometry]
      # @param client [Object]
      # @return [Vedeu::DSL::Geometry]
      def initialize(model, client = nil)
        @model  = model
        @client = client
      end

      # Instructs Vedeu to calculate x and y geometry automatically based on the
      # centre character of the terminal, the width and the height.
      #
      # @param value [Boolean] Any value other than nil or false will evaluate
      #   to true.
      #
      # @example
      #   geometry 'some_interface' do
      #     centred!
      #     # ...
      #   end
      #
      #   geometry 'some_interface' do
      #     centred false
      #     # ...
      #   end
      #
      # @return [Boolean]
      def centred(value = true)
        boolean = value ? true : false

        model.centred = boolean
      end
      alias_method :centred!, :centred

      # @see Vedeu::Grid.columns
      def columns(value)
        Vedeu::Grid.columns(value)
      end

      # Specify the number of characters/rows/lines tall the interface will be.
      #
      # @example
      #   geometry 'some_interface' do
      #     height 8
      #     # ...
      #   end
      #
      # @note
      #   This value will be ignored if by `y` and `yn` are set.
      #
      # @param value [Fixnum]
      # @return [Fixnum]
      def height(value)
        model.height = value
      end

      # @see Vedeu::Grid.columns
      def rows(value)
        Vedeu::Grid.rows(value)
      end

      # Specify the number of characters/columns wide the interface will be.
      #
      # @param value [Fixnum]
      #
      # @example
      #   geometry 'some_interface' do
      #     width 25
      #     # ...
      #   end
      #
      # @note
      #   This value will be ignored if by `x` and `xn` are set.
      #
      # @return [Fixnum]
      def width(value)
        model.width = value
      end

      # Specify the starting x position (column) of the interface.
      #
      # @example
      #   geometry 'some_interface' do
      #     x 7 # start on column 7.
      #     # ...
      #   end
      #
      #   geometry 'some_interface' do
      #     x { use('other_interface').east } # start on column 8, if
      #     # ...                             # `other_interface` changes
      #   end                                 # position, `some_interface` will
      #                                       # too.
      #
      # @param value [Fixnum]
      # @param block [Proc]
      # @return [Fixnum]
      def x(value = 1, &block)
        return model.x = block if block_given?

        model.x = value
      end

      # Specify the ending x position (column) of the interface.
      #
      # @example
      #   geometry 'some_interface' do
      #     xn 37 # end at column 37.
      #     # ...
      #   end
      #
      #   geometry 'some_interface' do
      #     xn  { use('other_interface').right } # if `other_interface` changes
      #     # ...                                # position, `some_interface`
      #   end                                    # will too.
      #
      # @note
      #   This value will override `width`.
      #
      # @param value [Fixnum]
      # @param block [Proc]
      # @return [Fixnum]
      def xn(value = 1, &block)
        return model.xn = block if block_given?

        model.xn = value
      end

      # Specify the starting y position (row/line) of the interface.
      #
      # @example
      #   geometry 'some_interface' do
      #     y  4
      #     # ...
      #   end
      #
      #   geometry 'some_interface' do
      #     y  { use('other_interface').north } # start on row/line 3, if
      #     # ...                               # `other_interface` changes
      #   end                                   # position, `some_interface`
      #                                         # will too.
      #
      # @param value [Fixnum]
      # @param block [Proc]
      # @return [Fixnum]
      def y(value = 1, &block)
        return model.y = block if block_given?

        model.y = value
      end

      # Specify the ending y position (row/line) of the interface.
      #
      # @example
      #   geometry 'some_interface' do
      #     yn 24 # end at row 24.
      #     # ...
      #   end
      #
      #   geometry 'some_interface' do
      #     yn { use('other_interface').bottom } # if `other_interface` changes
      #     # ...                                # position, `some_interface`
      #   end                                    # will too.
      #
      # @note
      #   This value will override `height`.
      #
      # @param value [Fixnum]
      # @param block [Proc]
      # @return [Fixnum]
      def yn(value = 1, &block)
        return model.yn = block if block_given?

        model.yn = value
      end

      protected

      # @!attribute [r] client
      # @return [Object]
      attr_reader :client

      # @!attribute [r] model
      # @return [Geometry]
      attr_reader :model

    end # Geometry

  end # DSL

end # Vedeu
