module Vedeu

  module CLI

    class Main < Thor

      desc 'new <name>', 'Create a skeleton Vedeu client application.'
      def new(name)
        say Vedeu::Generator::Application.generate(name)
      end

      # 'Specify the interface name lowercase snakecase; e.g. main_interface'
      desc 'view <name>',
           'Create a new interface within the client application.'
      def view(name)
        Vedeu::Generator::View.generate(name)
      end

      desc 'version',
           'Print the version.'
      def version
        say "vedeu #{Vedeu::VERSION}"
      end

    end # Main

  end # CLI

end # Vedeu
