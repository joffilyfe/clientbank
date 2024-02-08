# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Units::ValidationError do
  subject { described_class.new(errors) }

  let(:errors) { { name: 'fake' } }

  describe '#errors' do
    it { expect(subject.errors).to eq(errors) }
  end

  describe '#to_s' do
    it { expect(subject.to_s).to eq(errors.to_s) }
  end

  describe '#to_h' do
    it { expect(subject.to_h).to eq(errors.to_h) }
  end
end
