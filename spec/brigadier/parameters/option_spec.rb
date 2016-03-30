require 'spec_helper'

describe Brigadier::Parameters::Option do
  let(:name) { 'log-level' }
  let(:description) { 'Option description' }
  let(:validators) { [] }
  let(:args) { { default: 'info', required: true, validators: validators } }
  let(:block) { nil }

  subject { described_class.new(name, description, args, block) }

  describe '#display_name' do
    it 'returns a human readable name' do
      expect(subject.display_name).to eql('--log-level <value>')
    end
  end

  describe '#display_description' do
    it 'returns a human readable description' do
      expect(subject.display_description).to eql('Option description (default: info, required: true, current: "info")')
    end
  end

  describe '#validate!' do
    context 'with no custom validators' do
      context 'when value is not empty' do
        before do
          subject.value = 'debug'
        end

        it 'does not raiss an exception' do
          expect(subject.validate!).to eql(true)
        end
      end

      context 'when value is empty' do
        before do
          subject.value = nil
        end

        it 'raises an exception' do
          expect { subject.validate! }.to raise_error(/Value is empty/)
        end
      end
    end

    context 'with custom validators' do
      module CustomValidations
        class NoTrace
          include Brigadier::Validators::Base

          def failure_message
            'Trace is not supported'
          end

          def valid?
            value != 'trace'
          end
        end
      end

      let(:validators) { [ CustomValidations::NoTrace ] }

      before do
        subject.value = 'trace'
      end

      it 'does not raiss an exception' do
        expect { subject.validate! }.to raise_error(/Trace is not supported/)
      end
    end
  end
end
