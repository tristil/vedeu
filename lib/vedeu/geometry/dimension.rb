module Vedeu

  # A Dimension is either the height or width of an entity.
  #
  # @api private
  class Dimension

    # @param (see #initialize)
    # @return [Array<Fixnum>]
    def self.pair(attributes = {})
      new(attributes).pair
    end

    # Returns a new instance of Vedeu::Dimension.
    #
    # @param attributes [Hash<Symbol => Fixnum, NilClass>]
    # @option attributes d [Fixnum|NilClass] The starting value (y or x).
    # @option attributes dn [Fixnum|NilClass] The ending value (yn or xn).
    # @option attributes d_dn [Fixnum|NilClass] A width or a height.
    # @option attributes default [Fixnum|NilClass] The terminal width or height.
    # @option attributes options [Hash]
    # @return [Vedeu::Dimension]
    def initialize(attributes = {})
      @d       = attributes[:d]
      @dn      = attributes[:dn]
      @d_dn    = attributes[:d_dn]
      @default = attributes[:default]
      @options = attributes.fetch(:options, {})
    end

    # @return [Fixnum]
    def d1
      dimension.first < 1 ? 1 : dimension.first
    end

    # @return [Fixnum]
    def d2
      dimension.last
    end

    # @return [Array<Fixnum>]
    def pair
      dimension
    end

    protected

    # @!attribute [r] d
    # @return [Fixnum|NilClass]
    attr_reader :d

    # @!attribute [r] dn
    # @return [Fixnum|NilClass]
    attr_reader :dn

    # @!attribute [r] d_dn
    # @return [Fixnum|NilClass]
    attr_reader :d_dn

    # @!attribute [r] default
    # @return [Fixnum|NilClass]
    attr_reader :default

    private

    # @return [Array<Fixnum>]
    def dimension
      @dimension = if maximised?
                     [1, default]

                   elsif centred? && length?
                     [centred_d, centred_dn]

                   else
                     [_d, _dn]

                   end
    end

    # @return [Boolean]
    def length?
      default && length
    end

    # @return [Fixnum|NilClass]
    def length
      if d && dn
        (d..dn).size

      elsif d_dn
        d_dn

      elsif default
        default

      end
    end

    # @return [Boolean]
    def centred?
      options[:centred]
    end

    # @return [Fixnum]
    def centred_d
      (default / 2) - (length / 2)
    end

    # @return [Fixnum]
    def centred_dn
      (default / 2) + (length / 2)
    end

    # @return [Fixnum]
    def _d
      d || 1
    end

    # @return [Fixnum]
    def _dn
      if dn
        dn

      elsif d.nil? && d_dn
        d_dn

      elsif d && d_dn
        (d + d_dn) - 1

      else
        default

      end
    end

    # @return [Boolean]
    def maximised?
      options[:maximised]
    end

    # @return [Hash<Symbol => Boolean>]
    def options
      defaults.merge!(@options)
    end

    # @return [Hash<Symbol => Boolean>]
    def defaults
      {
        centred:   false,
        maximised: false,
      }
    end

  end # Dimension

end # Vedeu
