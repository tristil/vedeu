require 'test_helper'

module Vedeu

  describe Cell do

    let(:described)  { Vedeu::Cell }
    let(:instance)   { described.new(attributes) }
    let(:attributes) {
      {
        colour: colour,
        style:  style,
        value:  _value,
        x:      x,
        y:      y,
      }
    }
    let(:colour) { Colour.new(background: '#000000') }
    let(:style)  {}
    let(:_value) {}
    let(:x)      {}
    let(:y)      {}

    describe '#initialize' do
      it { instance.must_be_instance_of(described) }
      it { instance.instance_variable_get('@colour').must_equal(colour) }
      it { instance.instance_variable_get('@style').must_equal(style) }
      it { instance.instance_variable_get('@value').must_equal(_value) }
      it { instance.instance_variable_get('@x').must_equal(x) }
      it { instance.instance_variable_get('@y').must_equal(y) }
    end

    describe 'accessors' do
      it { instance.must_respond_to(:colour) }
      it { instance.must_respond_to(:style) }
      it { instance.must_respond_to(:value) }
      it { instance.must_respond_to(:x) }
      it { instance.must_respond_to(:y) }
    end

    describe '#eql?' do
      let(:other) { described.new(colour: Colour.new(background: '#000000')) }

      subject { instance.eql?(other) }

      it { subject.must_respond_to(:==) }

      it { subject.must_equal(true) }

      context 'when different to other' do
        let(:other) { described.new(colour: Colour.new(background: '#ff0000')) }

        it { subject.must_equal(false) }
      end
    end

  end # Cell

end # Vedeu
