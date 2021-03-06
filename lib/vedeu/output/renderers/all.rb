require_relative 'escape_sequence'
require_relative 'file'
require_relative 'html'
require_relative 'json'
require_relative 'null'
require_relative 'terminal'
require_relative 'text'

module Vedeu

  # Provides a single interface to all registered renderers.
  #
  # @api private
  module Renderers

    extend Enumerable
    extend self

    # Provides access to the list of renderers.
    #
    # @example
    #   Vedeu.renderers
    #
    # @api public
    # @return [Module]
    def renderers
      self
    end

    # @example
    #   Vedeu.renderers.render(*args)
    #
    # @return [Array<void>]
    def render(*args)
      threads = storage.map do |renderer|
        Thread.new(renderer) do
          mutex.synchronize do
            Vedeu.log(type: :debug, message: "Rendering with: '#{renderer}'")
            renderer.render(*args)
          end
        end
      end
      threads.each(&:join)
    end

    # Adds the given renderer class(es) to the list of renderers.
    #
    # @example
    #   Vedeu.renderer SomeRenderer
    #
    # @note
    #   A renderer class must respond to the '.render' class method.
    #
    # @param renderers [Class]
    # @return [Set]
    def renderer(*renderers)
      renderers.each { |renderer| storage.add(renderer) unless renderer.nil? }

      storage
    end

    # @example
    #   Vedeu.renderers.reset
    #
    # @return [Set]
    def reset
      @storage = Set.new
    end

    # @return [Set]
    def storage
      @storage ||= reset
    end

    private

    # @return [Mutex]
    def mutex
      @mutex ||= Mutex.new
    end

  end # Renderers

end # Vedeu
