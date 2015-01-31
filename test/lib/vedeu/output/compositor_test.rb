require 'test_helper'

module Vedeu

  # TODO: Leak detected. (GL 2015-01-28)

  describe Compositor do

    let(:described) { Vedeu::Compositor }
    let(:instance)  { described.new(_name) }
    let(:_name)     { 'compositor' }
    let(:buffer)    { Buffer.new(_name, interface) }
    let(:interface) {
      Vedeu.interface(_name) do
        geometry do
          height 5
          width  10
        end
        lines do
          line 'Some text.'
        end
      end
    }

    before do
      IO.console.stubs(:print)

      Vedeu.buffers.reset
      Vedeu.interfaces.reset
      Buffer.new(_name, interface).store
    end

    describe '#initialize' do
      subject { instance }

      it { subject.must_be_instance_of(Compositor) }
      it { subject.instance_variable_get('@name').must_equal(_name) }
    end

    describe '.compose' do
      subject { described.compose(_name) }

      # it { skip }

      context 'when there is no content' do
        # it { skip }
      end

      context 'when there is content' do
        context 'when the view has redefined the geometry' do
          # it { skip }
        end

        context 'when the view has not redefined the geometry' do
          it 'returns the escape sequences and content sent to the console' do
            subject.must_equal(
              [
                [
                  "\e[1;1H          \e[1;1H" \
                  "\e[2;1H          \e[2;1H" \
                  "\e[3;1H          \e[3;1H" \
                  "\e[4;1H          \e[4;1H" \
                  "\e[5;1H          \e[5;1H" \
                  "\e[1;1HSome text." \
                  "\e[2;1H          " \
                  "\e[3;1H          " \
                  "\e[4;1H          " \
                  "\e[5;1H          ",

                  "\e[1;1H\e[?25l"
                ]
              ]
            )
          end
        end
      end
    end

  end # Compositor

end # Vedeu
