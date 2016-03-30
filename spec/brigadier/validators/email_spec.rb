require 'spec_helper'

describe Brigadier::Validators::Email do
  let(:value) { nil }
  let(:obj) { double(value: value) }

  subject { described_class.new(obj) }

  context 'with an invalid email address' do
    let(:value) { 'bleep' }

    it 'raises an exception' do
      expect { subject.validate! }.to raise_error(/not a valid email address/)
    end
  end

  context 'with a valid email address' do
    let(:value) { 'user@domain.com' }

    it 'does not raise an exception' do
      expect(subject.validate!).to eql(true)
    end
  end
end
