module Vedeu
  module API
    class Base
      def self.build(attributes = {}, &block)
        new(attributes, &block).build
      end

      def initialize(attributes = {}, &block)
        @attributes                = attributes
        @self_before_instance_eval = eval('self', block.binding)

        instance_eval(&block)
      end

      def colour(values = {})
        fail InvalidArgument, '#colour expects a Hash containing :foreground,' \
                              ' :background or both.' unless values.is_a?(Hash)

        attributes[:colour] = values
      end

      def style(values = [], &block)
        if block_given?
          attributes[:streams] << API::Stream.build({ style: [values] }, &block)

        else
          [values].flatten.each { |value| attributes[:style] << value }

        end
      end

      private

      def method_missing(method, *args, &block)
        @self_before_instance_eval.send method, *args, &block
      end
    end
  end
end
