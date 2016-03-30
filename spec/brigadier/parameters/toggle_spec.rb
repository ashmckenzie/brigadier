require 'spec_helper'
require 'pry-byebug'

describe Brigadier::Parameters::Toggle do
  let(:name) { 'debug' }
  let(:description) { 'Toggle description' }
  let(:validators) { [] }
  let(:args) { { validators: validators } }
  let(:block) { nil }

  subject { described_class.new(name, description, args, block) }

  describe '#display_name' do
    it 'returns a human readable name' do
      expect(subject.display_name).to eql('--debug')
    end
  end

  describe '#display_description' do
    it 'returns a human readable description' do
      expect(subject.display_description).to eql('Toggle description (default: false)')
    end
  end

  describe '#enable!' do
    it 'enables' do
      subject.enable!
      expect(subject.enabled?).to be true
    end
  end

  describe '#disable!' do
    it 'disables' do
      subject.enable!
      subject.disable!
      expect(subject.enabled?).to be false
    end
  end

  describe '#enabled?' do
    context 'when not set' do
      it 'returns false' do
        expect(subject.enabled?).to be false
      end
    end

    context 'when explictly enabled' do
      it 'returns true' do
        subject.enable!
        expect(subject.enabled?).to be true
      end
    end

    context 'when explictly disabled' do
      it 'returns false' do
        subject.disable!
        expect(subject.enabled?).to be false
      end
    end
  end
end
