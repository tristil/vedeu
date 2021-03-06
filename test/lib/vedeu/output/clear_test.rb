require 'test_helper'

module Vedeu

  describe Clear do

    let(:described) { Vedeu::Clear }
    let(:instance)  { described.new(interface, options) }
    let(:interface) { Vedeu::Interface.new(name: 'xenon', visible: visible) }
    let(:options)   { {} }
    let(:visible)   { true }
    let(:drb)       { false }

    before do
      Vedeu::Border.new(name: 'xenon').store
      Vedeu::Geometry.new(name: 'xenon', x: 1, y: 1, xn: 3, yn: 3).store
      Vedeu::Configuration.stubs(:drb?).returns(drb)
      Vedeu.renderers.stubs(:render)
    end
    after do
      Vedeu.borders.reset
      Vedeu.geometries.reset
    end

    describe '#initialize' do
      it { instance.must_be_instance_of(described) }
      it { instance.instance_variable_get('@interface').must_equal(interface) }
      it { instance.instance_variable_get('@options').must_equal(options) }
    end

    describe 'alias methods' do
      it { described.must_respond_to(:render) }
    end

    describe '.by_group' do
      let(:group) {}

      subject { described.by_group(group) }

      it { described.must_respond_to(:by_group) }

      context 'when no group is given' do
        it { subject.must_equal(nil) }
      end
    end

    describe '.by_name' do
      subject { described.by_name(_name) }

      it { described.must_respond_to(:by_name) }
    end

    describe '.clear' do
      subject { described.clear(interface, options) }

      context 'when the interface is visible' do
        # it { skip }
        # it { subject.must_be_instance_of(Array) }
      end

      context 'when the interface is not visible' do
        let(:visible) { false }

        it { subject.must_be_instance_of(Array) }

        it { subject.must_equal([]) }
      end
    end

    describe '#clear' do
      subject { instance.clear }

      it { subject.must_be_instance_of(Array) }
      it { subject.flatten.size.must_equal(9) }

      context 'when the interface is visible' do
        # it { skip }
        # it { subject.must_be_instance_of(Array) }
      end

      context 'when the interface is not visible' do
        let(:visible) { false }

        it { subject.must_equal([]) }
      end
    end

    describe '#write' do
      subject { instance.write }

      context 'when the interface is visible' do
        # it { skip }
        # it { subject.must_be_instance_of(Array) }
      end

      context 'when the interface is not visible' do
        let(:visible) { false }

        it { subject.must_be_instance_of(NilClass) }
      end
    end

  end # Clear

end # Vedeu
