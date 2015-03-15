module Vedeu

  class V

    def initialize(y:, x:, yn:, xn:, oy:, ox:, oyn:, oxn:)
      @y, @x, @yn, @xn, @oy, @ox, @oyn, @oxn = y, x, yn, xn, oy, ox, oyn, oxn
    end

    def vp
      rows[@oy..@oyn].map { |cols| cols[@ox..@oxn] }
    end

    def y
      indexed.y
    end

    def x
      indexed.x
    end

    def yn
      indexed_n.y
    end

    def xn
      indexed_n.x
    end

    def indexed
      @indexed ||= Vedeu::PositionIndex[@y, @x]
    end

    def indexed_n
      @indexed_n ||= Vedeu::PositionIndex[@yn, @xn]
    end

    def rows
      Array.new(height) { |h| Array.new(width) { |w| [@y + h, @x + w] } }
    end

    def height
      @yn
    end

    def width
      @xn
    end

  end

end
