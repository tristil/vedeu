require 'vedeu/repositories/model'
require 'vedeu/output/presentation'

module Vedeu

  module RepositoryTestModule

    extend self

    def by_name(name)
      model
    end

    # The real repository stores the model and returns it.
    def store(model)
      model
    end

    private

    # A storage solution that uses memory to persist models.
    def in_memory
      {}
    end

  end # RepositoryTestModule

  class ModelTestClass

    include Vedeu::Model
    include Vedeu::Presentation

    attr_accessor :background, :colour, :name, :style

    def initialize(attributes = {})
      @attributes = defaults.merge!(attributes)

      @attributes.each { |key, value| instance_variable_set("@#{key}", value) }
    end

    private

    def defaults
      {
        colour:     {},
        name:       '',
        repository: Vedeu::RepositoryTestModule,
        style:      [],
      }
    end

  end # ModelTestClass

end # Vedeu
