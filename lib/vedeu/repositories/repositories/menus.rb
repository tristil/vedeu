module Vedeu

  # Allows the storing of menus by name.
  #
  # @api public
  class Menus < Repository

    class << self

      # @example
      #   Vedeu.menus
      #
      # @return [Vedeu::Menus]
      alias_method :menus, :repository

      # Remove all stored models from the repository.
      #
      # @example
      #   Vedeu.menus.reset!
      #
      # @return [Vedeu::Menus]
      def reset!
        @menus = register(Vedeu::Menu)
      end

    end

  end # Menus

end # Vedeu
