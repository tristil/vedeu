require 'test_helper'

module Vedeu

  module Null

    describe Border do

      let(:described) { Vedeu::Null::Border }
      let(:instance)  { described.new(_name) }
      let(:_name)     { 'null_border' }
      let(:geometry)  {
        Vedeu::Geometry.new(name: _name, x: 4, y: 6, xn: 10, yn: 12)
      }

      before { Vedeu.geometries.stubs(:by_name).returns(geometry) }

      describe '#initialize' do
        it { instance.must_be_instance_of(described) }
        it { instance.instance_variable_get('@name').must_equal(_name) }
      end

      describe '#bx' do
        subject { instance.bx }

        it { subject.must_be_instance_of(Fixnum) }
        it { subject.must_equal(4) }
      end

      describe '#by' do
        subject { instance.by }

        it { subject.must_be_instance_of(Fixnum) }
        it { subject.must_equal(6) }
      end

      describe '#bxn' do
        subject { instance.bxn }

        it { subject.must_be_instance_of(Fixnum) }
        it { subject.must_equal(10) }
      end

      describe '#byn' do
        subject { instance.byn }

        it { subject.must_be_instance_of(Fixnum) }
        it { subject.must_equal(12) }
      end

      describe '#enabled?' do
        subject { instance.enabled? }

        it { subject.must_be_instance_of(FalseClass) }
      end

      describe '#height' do
        subject { instance.height }

        it { subject.must_be_instance_of(Fixnum) }
        it { subject.must_equal(7) }
      end

      describe '#render' do
        subject { instance.render }

        it { subject.must_be_instance_of(Array) }
        it { subject.must_equal([]) }
      end

      describe '#width' do
        subject { instance.width }

        it { subject.must_be_instance_of(Fixnum) }
        it { subject.must_equal(7) }
      end

    end # Border

  end # Null

end # Vedeu
