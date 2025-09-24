require 'spec_helper'

RSpec.describe PricingMatrix do
  subject { described_class.new(sample_prices_json) }

  describe '#cost_for' do
    it 'returns correct SMS prices' do
      expect(subject.cost_for('sms', 'AU')).to eq(0.50)
      expect(subject.cost_for('sms', 'NZ')).to eq(0.45)
      expect(subject.cost_for('sms', 'UK')).to eq(0.40)
    end

    it 'returns correct email prices' do
      expect(subject.cost_for('email', 'AU')).to eq(0.10)
      expect(subject.cost_for('email', 'NZ')).to eq(0.08)
      expect(subject.cost_for('email', 'UK')).to eq(0.12)
    end
  end

  describe 'initialization' do
    it 'parses JSON correctly' do
      expect { subject }.not_to raise_error
    end

    context 'with invalid JSON' do
      subject { described_class.new('invalid json') }

      it 'raises JSON::ParserError' do
        expect { subject }.to raise_error(JSON::ParserError)
      end
    end

    context 'with invalid price structure' do
      let(:invalid_prices_json) { '[{"notification_type": "sms"}]' }  # missing prices
      
      it 'raises validation error' do
        expect { described_class.new(invalid_prices_json) }.to raise_error("Invalid price entry: missing 'prices'")
      end
    end
  end

  describe '#cost_for error handling' do
    context 'with nil type' do
      it 'raises validation error' do
        expect { subject.cost_for(nil, 'AU') }.to raise_error("Notification type cannot be nil or empty")
      end
    end

    context 'with empty country' do
      it 'raises validation error' do
        expect { subject.cost_for('sms', '') }.to raise_error("Country cannot be nil or empty")
      end
    end

    context 'with unsupported type/country combo' do
      it 'raises no price found error' do
        expect { subject.cost_for('sms', 'US') }.to raise_error("No price found for 'sms' notifications in 'US'")
      end
    end
  end
end
