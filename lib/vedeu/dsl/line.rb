module Vedeu

  module DSL

    # Provides methods to be used to define views.
    #
    # @example
    #   Vedeu.renders do
    #     view 'my_interface' do
    #       lines do
    #         background '#000000'
    #         foreground '#ffffff'
    #         line 'This is white text on a black background.'
    #         line 'Next is a blank line:'
    #         line ''
    #
    #         streams { stream 'We can define ' }
    #
    #         streams do
    #           foreground '#ff0000'
    #           stream 'parts of a line '
    #         end
    #
    #         streams { stream 'independently using ' }
    #
    #         streams do
    #           foreground '#00ff00'
    #           stream 'streams.'
    #         end
    #       end
    #     end
    #   end
    #
    # @api public
    class Line

      include Vedeu::DSL
      include Vedeu::DSL::Presentation
      include Vedeu::DSL::Text

      # Returns an instance of DSL::Line.
      #
      # @param model [Vedeu::Line]
      # @param client [Object]
      # @return [Vedeu::DSL::Line]
      def initialize(model, client = nil)
        @model  = model
        @client = client
      end

      # Specify a single line in a view.
      #
      # @example
      #   Vedeu.renders do
      #     view 'my_interface' do
      #       line 'some text...'
      #       # ...
      #
      #       line do
      #         # ...
      #       end
      #     end
      #   end
      #
      # @raise [InvalidSyntax] When no block or value is provided.
      # @return [Vedeu::Lines]
      def line(value = '', &block)
        if block_given?
          content = Vedeu::Line.build({ client: client,
                                        parent: model.parent }, &block)

        elsif value
          content = Vedeu::Line.build(client:  client,
                                      parent:  model.parent,
                                      streams: [build_stream(value)])

        else
          fail InvalidSyntax, 'block not given'

        end

        model.parent.add(content)
      end

      # Define multiple streams (a stream is a subset of a line).
      # Uses {Vedeu::DSL::Stream} for all directives within the required block.
      #
      # @param block [Proc]
      #
      # @example
      #   Vedeu.renders do
      #     view 'my_interface' do
      #       line do
      #         streams do
      #           # ...
      #         end
      #
      #         stream do
      #           # ...
      #         end
      #       end
      #     end
      #   end
      #
      # @raise [InvalidSyntax] The required block was not given.
      # @return [Vedeu::Streams<Vedeu::Stream>]
      # @see Vedeu::DSL::Stream for subdirectives.
      def streams(&block)
        fail InvalidSyntax, 'block not given' unless block_given?

        model.add(model.member.build(attributes, &block))
      end
      alias_method :stream, :streams

      protected

      # @!attribute [r] client
      # @return [Object]
      attr_reader :client

      # @!attribute [r] model
      # @return [Line]
      attr_reader :model

      private

      # @return [Hash]
      def attributes
        {
          client: client,
          parent: model,
        }
      end

      # @param value [String]
      # @return [Vedeu::Stream]
      def build_stream(value)
        Vedeu::Stream.build(client: client, parent: model, value: value)
      end

    end # Line

  end # DSL

end # Vedeu
