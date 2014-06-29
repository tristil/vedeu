require_relative '../../../test_helper'

module Vedeu
  describe Events do
    let(:described_class)    { Events }
    let(:described_instance) { described_class.new }

    describe '#initialize' do
      let(:subject) { described_instance }

      it 'returns an Events instance' do
        subject.must_be_instance_of(Events)
      end

      it 'sets an instance variable' do
        subject.instance_variable_get('@handlers')
          .must_be_instance_of(Hash)
      end
    end

    describe '#on' do
      let(:subject) { described_instance.on(event) { :do_something } }
      let(:event)   { :some_event }

      it 'returns the handlers value' do
        subject.must_be_instance_of(Array)
      end
    end

    describe '#trigger' do
      let(:subject) { described_instance.trigger(event, args) }
      let(:event)   { :some_event }
      let(:args)    {}
    end
  end
end
