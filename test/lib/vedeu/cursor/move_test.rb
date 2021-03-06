require 'test_helper'

module Vedeu

  describe Move do

    let(:described) { Vedeu::Move }
    let(:instance)  { described.new(entity, _name, dy, dx) }
    let(:entity)    { Vedeu::Cursor }
    let(:_name)     { '' }
    let(:dy)        { 0 }
    let(:dx)        { 0 }
    let(:ox)        { 0 }
    let(:oy)        { 0 }
    let(:x)         { 1 }
    let(:y)         { 1 }

    before do
      Vedeu::Cursor.new(name:    'move_with_border',
                        ox:      ox,
                        oy:      oy,
                        visible: true,
                        x:       x,
                        y:       y).store
      Vedeu::Cursor.new(name:    'move_without_border',
                        ox:      ox,
                        oy:      oy,
                        visible: true,
                        x:       x,
                        y:       y).store
      Vedeu.border 'move_with_border' do
        # ...
      end
      Vedeu.geometry 'move_with_border' do
        x  5
        xn 10
        y  5
        yn 10
      end
      Vedeu.geometry 'move_without_border' do
        x  5
        xn 10
        y  5
        yn 10
      end
      IO.console.stubs(:winsize).returns([25, 80])
      IO.console.stubs(:print)
    end
    after do
      Vedeu.borders.reset
      Vedeu.cursors.reset
      Vedeu.geometries.reset
    end

    describe '#initialize' do
      it { instance.must_be_instance_of(described) }
      it { instance.instance_variable_get('@entity').must_equal(entity) }
      it { instance.instance_variable_get('@name').must_equal(_name) }
      it { instance.instance_variable_get('@dy').must_equal(dy) }
      it { instance.instance_variable_get('@dx').must_equal(dx) }
    end

    describe '.by_name' do
      let(:direction) { :down }
      let(:_name)     { 'manganese' }

      before do
        Vedeu::Cursor.new(name: 'manganese', oy: 2, ox: 3, x: 8, y: 7).store
      end

      subject { described.by_name(entity, direction, _name) }

      it { subject.must_be_instance_of(Vedeu::Cursor) }

      context 'when the name is not specified' do
        let(:_name) {}

        # it { skip }
      end

      context 'when the name is specified' do
        let(:_name) { 'manganese' }

        context 'and the direction is down' do
          let(:direction) { :down }

          it { subject.oy.must_equal(3) }
        end
        context 'and the direction is left' do
          let(:direction) { :left }

          it { subject.ox.must_equal(2) }
        end
        context 'and the direction is right' do
          let(:direction) { :right }

          it { subject.ox.must_equal(4) }
        end
        context 'and the direction is up' do
          let(:direction) { :up }

          it { subject.oy.must_equal(1) }
        end
      end
    end

    describe '.down' do
      let(:_name) { 'move_down' }

      subject { described.down(entity, _name) }

      it { subject.must_be_instance_of(Vedeu::Cursor) }

      it { subject.y.must_equal(2) }

      context 'when within the boundary of the interface' do
        let(:_name) { 'move_without_border' }
        let(:oy)    { 15 }

        it 'does not move past the bottom of the interface' do
          subject.y.must_equal(10)
        end
      end

      context 'when within the border of the interface' do
        let(:_name) { 'move_with_border' }
        let(:oy)    { 15 }

        it 'does not move past the bottom border' do
          subject.y.must_equal(9)
        end
      end
    end

    describe '.left' do
      let(:_name) { 'move_left' }

      subject { described.left(entity, _name) }

      it { subject.must_be_instance_of(Vedeu::Cursor) }

      it { subject.x.must_equal(1) }

      context 'when within the boundary of the interface' do
        let(:_name) { 'move_without_border' }

        it 'does not move past the left of the interface' do
          subject.x.must_equal(5)
        end
      end

      context 'when within the border of the interface' do
        let(:_name) { 'move_with_border' }

        it 'does not move past the left border' do
          subject.x.must_equal(6)
        end
      end
    end

    describe '.right' do
      let(:_name) { 'move_right' }

      subject { described.right(entity, _name) }

      it { subject.must_be_instance_of(Vedeu::Cursor) }

      it { subject.x.must_equal(2) }

      context 'when within the boundary of the interface' do
        let(:_name) { 'move_without_border' }
        let(:ox)    { 15 }

        it 'does not move past the right of the interface' do
          subject.x.must_equal(10)
        end
      end

      context 'when within the border of the interface' do
        let(:_name) { 'move_with_border' }
        let(:ox)    { 15 }

        it 'does not move past the right border' do
          subject.x.must_equal(9)
        end
      end
    end

    describe '.up' do
      let(:_name) { 'move_up' }

      subject { described.up(entity, _name) }

      it { subject.must_be_instance_of(Vedeu::Cursor) }

      it { subject.y.must_equal(1) }

      context 'when within the boundary of the interface' do
        let(:_name) { 'move_without_border' }

        it 'does not move past the top of the interface' do
          subject.y.must_equal(5)
        end
      end

      context 'when within the border of the interface' do
        let(:_name) { 'move_with_border' }

        it 'does not move past the top border' do
          subject.y.must_equal(6)
        end
      end
    end

    describe '.origin' do
      let(:_name) { 'move_origin' }

      subject { described.origin(entity, _name) }

      it { subject.must_be_instance_of(Vedeu::Cursor) }

      context 'within the visible area for the console' do
        it { subject.x.must_equal(1) }
        it { subject.y.must_equal(1) }
      end

      context 'within the boundary of the interface' do
        let(:_name) { 'move_without_border' }

        it { subject.x.must_equal(5) }
        it { subject.y.must_equal(5) }
      end

      context 'within the border of the interface' do
        let(:_name) { 'move_with_border' }

        it { subject.x.must_equal(6) }
        it { subject.y.must_equal(6) }
      end
    end

    describe '#move' do
      let(:_name) { 'move_move' }

      subject { instance.move }

      context 'when the entity is a Vedeu::Geometry' do
        let(:entity) { Vedeu::Geometry }

        # it { skip }
      end

      context 'when the entity is a Vedeu::Cursor' do
        it { subject.must_be_instance_of(Vedeu::Cursor) }
      end
    end

    describe '#refresh' do
      subject { instance.refresh }

      context 'when the entity is a Vedeu::Geometry' do
        let(:entity) { Vedeu::Geometry }

        # it { skip }
      end

      context 'when the entity is a Vedeu::Cursor' do
        # it { skip }
      end
    end

    describe '#merged_attributes' do
      subject { instance.merged_attributes }

      context 'when the entity is a Vedeu::Geometry' do
        let(:entity) { Vedeu::Geometry }

        it { subject.must_be_instance_of(Hash) }
      end

      context 'when the entity is a Vedeu::Cursor' do
        # it { skip }
      end
    end

  end # Move

end # Vedeu
