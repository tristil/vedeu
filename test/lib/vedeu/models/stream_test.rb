require 'test_helper'

module Vedeu

  describe Stream do

    let(:described)  { Vedeu::Stream }
    let(:instance)   { described.new(attributes) }
    let(:attributes) {
      {
        value:  _value,
        parent: parent,
        colour: colour,
        style:  style
      }
    }
    let(:_value)  { 'Some text' }
    let(:parent) {
      Line.new(streams: [],
               parent:  line_parent,
               colour:  parent_colour,
               style:   Style.new('normal'))
    }
    let(:parent_colour) {
      Colour.new(background: '#0000ff', foreground: '#ffff00')
    }
    let(:colour)      {
      Colour.new(background: '#ff0000', foreground: '#000000')
    }
    let(:style)       { Style.new('normal') }
    let(:line_parent) { Vedeu::Interface.new(name: 'Vedeu::Stream') }

    describe '#initialize' do
      it { instance.must_be_instance_of(described) }
      it { instance.instance_variable_get('@value').must_equal(_value) }
      it { instance.instance_variable_get('@parent').must_equal(parent) }
    end

    describe 'accessors' do
      it { instance.must_respond_to(:parent) }
      it { instance.must_respond_to(:parent=) }
      it { instance.must_respond_to(:value) }
      it { instance.must_respond_to(:content) }
      it { instance.must_respond_to(:data) }
      it { instance.must_respond_to(:text) }
      it { instance.must_respond_to(:value=) }
      it { instance.must_respond_to(:attributes) }
    end

    describe '#add' do
      let(:child) { instance }

      subject { instance.add(child) }

      it { subject.must_be_instance_of(Vedeu::Streams) }
    end

    describe '#chars' do
      subject { instance.chars }

      it { subject.must_be_instance_of(Array) }

      context 'when there is content' do
        it { subject.size.must_equal(9) }
      end

      context 'when there is no content' do
        let(:_value) { '' }

        it 'returns an empty collection' do
          subject.must_equal([])
        end
      end
    end

    describe '#empty?' do
      subject { instance.empty? }

      context 'when there is no content' do
        let(:_value) { '' }

        it { subject.must_equal(true) }
      end

      context 'when there is content' do
        it { subject.must_equal(false) }
      end
    end

    describe '#eql?' do
      let(:other) { described.new(attributes) }

      subject { instance.eql?(other) }

      it { subject.must_equal(true) }

      context 'when different to other' do
        let(:other) { described.new(colour: Colour.coerce({ background: '#ff0000' })) }

        it { subject.must_equal(false) }
      end
    end

    describe '#name' do
      subject { instance.name }

      context 'when a parent is defined' do
        it { subject.must_be_instance_of(String) }
      end

      context 'when a parent is not defined' do
        before { instance.stubs(:parent) }

        it { subject.must_be_instance_of(NilClass) }
      end
    end

    describe '#size' do
      subject { instance.size }

      it { subject.must_be_instance_of(Fixnum) }

      it 'returns the size of the stream' do
        subject.must_equal(9)
      end
    end

    describe '#width' do
      before { line_parent.stubs(:width).returns(25) }

      subject { instance.width }

      it { subject.must_be_instance_of(Fixnum) }
      it { subject.must_equal(25) }
    end

  end # Stream

end # Vedeu
