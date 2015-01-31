require 'vedeu/cursor/cursor'
require 'vedeu/support/terminal'

module Vedeu

  # Adjusts the position of the cursor.
  #
  class MoveCursor

    extend Forwardable

    def_delegators :@interface, :border,
                                :border?,
                                :content,
                                :content?,
                                :content_geometry,
                                :geometry
    def_delegators Terminal, :height,
                             :width

    # @param cursor    [Cursor]
    # @param interface [Interface]
    # @param dy        [Fixnum] Move up (-1), or down (1), or no action (0).
    # @param dx        [Fixnum] Move left (-1), or right (1), or no action (0).
    # @return [MoveCursor]
    def initialize(cursor, interface, dy, dx)
      @cursor    = cursor
      @dy        = dy
      @dx        = dx
      @interface = interface
    end

    # Moves the cursor down by one row.
    #
    # @return [Cursor]
    def self.down(cursor, interface)
      new(cursor, interface, 1, 0).move
    end

    # Moves the cursor left by one column.
    #
    # @return [Cursor]
    def self.left(cursor, interface)
      new(cursor, interface, 0, -1).move
    end

    # Moves the cursor right by one column.
    #
    # @return [Cursor]
    def self.right(cursor, interface)
      new(cursor, interface, 0, 1).move
    end

    # Moves the cursor up by one row.
    #
    # @return [Cursor]
    def self.up(cursor, interface)
      new(cursor, interface, -1, 0).move
    end

    # Moves the cursor to the top left coordinate of the interface.
    #
    # @return [Cursor]
    def self.origin(cursor, interface)
      new(cursor, interface, (0 - cursor.y), (0 - cursor.x)).move
    end

    # Returns a newly positioned and stored Cursor.
    #
    # @return [Cursor]
    def move
      Cursor.new({ name:  cursor.name,
                   ox:    new_ox,
                   oy:    new_oy,
                   state: cursor.state,
                   x:     new_x,
                   y:     new_y }).store
    end

    private

    attr_reader :cursor, :dx, :dy, :interface

    # Returns the x coordinate (column/character) of the cursor. Attempts to
    # sensibly reposition the cursor if it is currently outside the interface,
    # or outside the visible area of the terminal.
    #
    # When the interface has a top, right, bottom or left border, then the
    # cursor will be repositioned to be inside the border not on it.
    #
    # @return [Fixnum]
    def new_x
      x = cursor.x + dx

      x = 1     if x <= 1
      x = width if x >= width

      if border? && border.left? && x <= (geometry.left + 1)
        x = geometry.left + 1

      elsif x <= geometry.left
        x = geometry.left

      elsif border? && border.right? && x >= (geometry.right - 1)
        x = geometry.right - 2 # TODO: can't remember why this is 2 and not 1

      elsif x >= geometry.right
        x = geometry.right

      else
        x

      end
    end

    # Returns the y coordinate (row/line) of the cursor.
    #
    # @see MoveCursor#new_x for more details on behaviour.
    # @return [Fixnum]
    def new_y
      y = cursor.y + dy

      y = 1      if y <= 1
      y = height if y >= height

      if border? && border.top? && y <= (geometry.top + 1)
        y = geometry.top + 1

      elsif y <= geometry.top
        y = geometry.top

      elsif border? && border.bottom? && y >= (geometry.bottom - 1)
        y = geometry.bottom - 2 # TODO: can't remember why this is 2 and not 1

      elsif y >= geometry.bottom
        y = geometry.bottom

      else
        y

      end
    end

    def new_ox
      ox = cursor.ox + dx

      ox = 0                      if ox <= 0
      ox = content_geometry.width if ox >= content_geometry.width

      ox
    end

    def new_oy
      oy = cursor.oy + dy

      oy = 0                       if oy <= 0
      oy = content_geometry.height if oy >= content_geometry.height

      oy
    end

  end # MoveCursor

end # Vedeu
