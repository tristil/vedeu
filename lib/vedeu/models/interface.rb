module Vedeu
  class Interface
    include Coercions
    include Presentation

    extend Forwardable

    def_delegators :geometry, :north, :east, :south, :west,
                              :top, :right, :bottom, :left,
                              :width, :height, :origin,
                              :viewport_width, :viewport_height

    attr_reader :attributes, :delay, :group, :name

    # @param  attributes [Hash]
    # @param  block [Proc]
    # @return [Hash]
    def self.build(attributes = {}, &block)
      new(attributes, &block).attributes
    end

    # @see Vedeu::API#interface
    # @param attributes [Hash]
    # @param block [Proc]
    # @return []
    def self.define(attributes = {}, &block)
      new(attributes).define(&block)
    end

    # @param  attributes [Hash]
    # @param  block [Proc]
    # @return [Interface]
    def initialize(attributes = {}, &block)
      @attributes = defaults.merge!(attributes)

      @name  = @attributes[:name]
      @group = @attributes[:group]
      @delay = @attributes[:delay]

      if block_given?
        @self_before_instance_eval = eval('self', block.binding)

        instance_eval(&block)
      end
    end

    # @see Vedeu::API#interface
    # @param block [Proc]
    #
    # @example
    #   TODO
    #
    # @return []
    def define(&block)
      instance_eval(&block) if block_given?

      if attributes[:name].nil? || attributes[:name].empty?
        fail InvalidSyntax, 'Interfaces and views must have a `name`.'
      end

      Vedeu::Buffers.create(attributes)

      Vedeu.event("_refresh_#{attributes[:name]}_".to_sym,
                  { delay: attributes[:delay] }) do
        Vedeu::Buffers.refresh(attributes[:name])
      end

      self
    end

    # @return [Array]
    def lines
      @lines ||= Line.coercer(attributes[:lines])
    end

    # @return [Geometry]
    def geometry
      @geometry ||= Geometry.new(attributes[:geometry])
    end

    # @return [String]
    def cursor
      @cursor ||= if attributes[:cursor] == true
        Esc.string('show_cursor')

      else
        Esc.string('hide_cursor')

      end
    end

    # @return [String]
    def to_s
      Render.call(self)
    end

    # @return [String]
    def clear
      Clear.call(self)
    end

    private

    # @api private
    # @return [Hash]
    def defaults
      {
        name:     '',
        group:    '',
        lines:    [],
        colour:   {},
        style:    '',
        geometry: {},
        cursor:   true,
        delay:    0.0
      }
    end

    # @api private
    # @return [String]
    def out_of_bounds(name)
      "Note: For this terminal, the value of '#{name}' may lead to content " \
      "that is outside the viewable area."
    end

    # @api private
    # @return [TrueClass|FalseClass]
    def y_out_of_bounds?(value)
      value < 1 || value > Terminal.height
    end

    # @api private
    # @return [TrueClass|FalseClass]
    def x_out_of_bounds?(value)
      value < 1 || value > Terminal.width
    end

    # @api private
    # @return []
    def method_missing(method, *args, &block)
      @self_before_instance_eval.send(method, *args, &block)
    end

  end
end
