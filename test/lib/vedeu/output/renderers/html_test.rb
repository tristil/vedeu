require 'test_helper'

module Vedeu

  module Renderers

    describe HTML do

      let(:described) { Vedeu::Renderers::HTML }
      let(:instance)  { described.new(output) }
      let(:output)    {}

      before do
        ::File.stubs(:open)
      end

      describe '#initialize' do
        it { instance.must_be_instance_of(described) }
        it { instance.instance_variable_get('@output').must_equal(output) }
      end

      describe '.render' do
        it { described.must_respond_to(:render) }
      end

      describe '.to_file' do
        it { described.must_respond_to(:to_file) }
      end

      describe '#render' do
        before { ::File.stubs(:open) }

        subject { instance.render }

        it { subject.must_be_instance_of(String) }
      end

      describe '#to_file' do
        before { ::File.stubs(:open) }

        subject { instance.to_file(path) }

        context 'when a path is given' do
          let(:path) { '/tmp/test_vedeu_html_renderer.html' }

          it do
            ::File.expects(:open)
            subject
          end
        end

        context 'when a path is not given' do
          let(:path) {}
          let(:_time) { Time.new(2015, 4, 12, 16, 55) }

          before { Time.stubs(:now).returns(_time) }

          it do
            ::File.expects(:open)#.with('/tmp/vedeu_html_1428854100.html', 'w')
            subject
          end
        end
      end

      describe '#html_body' do
        subject { instance.html_body }

        it { subject.must_be_instance_of(String) }

        it { subject.must_equal('') }

        context 'when there is output' do
          let(:output) {
            [
              [
                Vedeu::Char.new(value: 't'),
                Vedeu::Char.new(value: 'e'),
                Vedeu::Char.new(value: 's'),
                Vedeu::Char.new(value: 't'),
              ]
            ]
          }

          it { subject.must_equal(
            "<tr>\n" \
            "<td style='background:#000;color:#222;border:1px #000 solid;'>"   \
            "t</td>\n" \
              "<td style='background:#000;color:#222;border:1px #000 solid;'>" \
            "e</td>\n" \
              "<td style='background:#000;color:#222;border:1px #000 solid;'>" \
            "s</td>\n" \
              "<td style='background:#000;color:#222;border:1px #000 solid;'>" \
            "t</td>\n" \
            "</tr>\n") }
        end
      end

    end # HTML

  end # Renderers

end # Vedeu
