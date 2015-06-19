module Vedeu

  module RepositoryAPI

    def repo(name, model)
      send(:define_singleton_method, name) do
        unless instance_variable_defined?("@#{name}")
          instance_variable_set("@#{name}", self.send(:instantiate, model))
        end

        instance_variable_get("@#{name}")
      end

      Vedeu.send(:define_singleton_method, name) do
       ̣ # model.send(:repo)
      end
    end

    def reset
      self.reset
    end

    def instantiate(model)
      @repo ||= new(model)
    end

  end # RepositoryAPI

  class RepoTest < Repository

    extend Vedeu::RepositoryAPI

    repo :monkey, Vedeu::Events

  end

  # class SomeTest < Repository

  #   include Vedeu::RepositoryAPI

  #   repo :some, Vedeu::Buffers

  # end

end # Vedeu
