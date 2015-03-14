require 'singleton'

module Vedeu

  class Canvas

    include Singleton

    # @return [Vedeu::Canvas]
    def self.canvas
      instance
    end

    # @param yn [Fixnum]
    # @param xn [Fixnum]
    # @return [Vedeu::Canvas]
    def configure(yn, xn)
      @yn = yn
      @xn = xn

      self
    end

    # @return [Array]
    def c
      [cy, cx]
    end
    alias_method :centre, :c

    # @return [Fixnum]
    def cy
      ((yn - y) / 2) + y
    end
    alias_method :centre_y, :cy

    # @return [Fixnum]
    def cx
      ((xn - x) / 2) + x
    end
    alias_method :centre_x, :cx

    # @return [Fixnum]
    def o
      1
    end
    alias_method :origin, :o

    # @return [Fixnum]
    def y
      1
    end
    alias_method :top, :y

    # @return [Fixnum]
    def yn
      @yn
    end
    alias_method :bottom, :yn
    alias_method :height, :yn

    # @return [Fixnum]
    def x
      1
    end
    alias_method :left, :x

    # @return [Fixnum]
    def xn
      @xn
    end
    alias_method :right, :xn
    alias_method :width, :xn

  end # Canvas

end # Vedeu
