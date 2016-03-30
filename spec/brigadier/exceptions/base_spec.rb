require 'spec_helper'

describe Brigadier::Exceptions::Base do
  let(:name) { 'obj' }
  let(:obj) { double(name: name) }

  subject { described_class.new(obj) }

  it 'bleeps' do
    expect(subject.as_str).to eql("Double 'obj': Brigadier::Exceptions::Base")
  end
end
