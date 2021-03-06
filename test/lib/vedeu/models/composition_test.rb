require 'test_helper'

module Vedeu

  describe Composition do

    let(:described)  { Vedeu::Composition }
    let(:instance)   { described.new(attributes) }
    let(:attributes) {
      {
        interfaces: interfaces,
        colour:     colour,
        style:      style,
      }
    }
    let(:interfaces) { [] }
    let(:colour)     {}
    let(:style)      {}

    describe '.build' do
      subject {
        described.build({}) do
          # ...
        end
      }

      it { subject.must_be_instance_of(described) }
    end

    describe '#initialize' do
      it { instance.must_be_instance_of(described) }
      it { instance.instance_variable_get('@interfaces').must_equal(interfaces) }
    end

    describe '#add' do
      let(:child) { Vedeu::Interface.new }

      subject { instance.add(child) }

      it { subject.must_be_instance_of(Vedeu::InterfaceCollection) }
    end

    describe '#interfaces' do
      subject { instance.interfaces }

      it { subject.must_be_instance_of(Vedeu::InterfaceCollection) }
    end

    describe '#parent' do
      subject { instance.parent }

      it { subject.must_be_instance_of(NilClass) }
    end

  end # Composition

end # Vedeu
