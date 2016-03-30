require 'spec_helper'
require 'pry-byebug'

describe Brigadier::Parameters::Argument do
  let(:name) { 'name' }
  let(:description) { 'Name description' }
  let(:validators) { [] }
  let(:valid_values) { [] }
  let(:args) { { validators: validators, valid_values: valid_values } }
  let(:block) { nil }

  subject { described_class.new(name, description, args, block) }

  describe '#display_name' do
    it 'returns a human readable name' do
      expect(subject.display_name).to eql('name')
    end
  end

  describe '#display_description' do
    it 'returns a human readable description' do
      expect(subject.display_description).to eql('Name description (current: nil)')
    end
  end

  describe '#valid_values' do
    context 'when not set' do
      it 'is empty' do
        expect(subject.valid_values).to eql([])
      end
    end

    context 'when set' do
      let(:valid_values) { %w( john ) }

      it 'is not empty' do
        expect(subject.valid_values).to eql(%w( john ))
      end
    end
  end

  describe '#required?' do
    it 'returns true' do
      expect(subject.required?).to be true
    end
  end

  describe '#validate!' do
    context 'with no custom validators' do
      context 'when value is not empty' do
        before do
          subject.value = 'john'
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

      context 'when valid values are defined' do
        let(:valid_values) { %w( jim ) }

        before do
          subject.value = 'jane'
        end

        it 'raises an exception' do
          expect { subject.validate! }.to raise_error(/Value is invalid/)
        end
      end
    end

    context 'with custom validators' do
      module CustomValidations
        class John
          include Brigadier::Validators::Base

          def failure_message
            'Must be John!'
          end

          def valid?
            value == 'john'
          end
        end
      end

      let(:validators) { [ CustomValidations::John ] }

      before do
        subject.value = 'jane'
      end

      it 'does not raiss an exception' do
        expect { subject.validate! }.to raise_error(/Must be John!/)
      end
    end
  end
end
