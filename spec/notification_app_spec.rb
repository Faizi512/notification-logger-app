require 'spec_helper'

RSpec.describe NotificationApp do
  describe '.call' do
    subject { described_class.call(sample_prices_json, sample_logs_json) }

    it 'returns array of company summaries' do
      expect(subject).to be_an(Array)
      expect(subject.length).to eq(3)
    end

    it 'returns summaries with correct structure' do
      summary = subject.first
      expect(summary).to have_key('company')
      expect(summary).to have_key('notification_count')
      expect(summary).to have_key('cost')
    end

    it 'calculates correct totals for Sharesies' do
      sharesies = subject.find { |s| s['company'] == 'Sharesies' }
      
      expect(sharesies['notification_count']).to eq(4)
      # 1×0.50 (AU SMS) + 1×0.45 (NZ SMS) + 2×0.40 (UK SMS) = 1.75
      expect(sharesies['cost']).to eq(1.75)
    end

    it 'calculates correct totals for Mighty Ape' do
      mighty_ape = subject.find { |s| s['company'] == 'Mighty Ape' }
      
      expect(mighty_ape['notification_count']).to eq(3)
      # 2×0.08 (NZ Email) + 1×0.50 (AU SMS) = 0.66
      expect(mighty_ape['cost']).to eq(0.66)
    end

    it 'calculates correct totals for TradeMe' do
      trademe = subject.find { |s| s['company'] == 'TradeMe' }
      
      expect(trademe['notification_count']).to eq(4)
      # 2×0.45 (NZ SMS) + 2×0.08 (NZ Email) = 1.06
      expect(trademe['cost']).to eq(1.06)
    end

    context 'with empty logs' do
      subject { described_class.call(sample_prices_json, '[]') }

      it 'returns empty array' do
        expect(subject).to eq([])
      end
    end

    context 'with invalid prices JSON' do
      subject { described_class.call('invalid json', sample_logs_json) }

      it 'raises JSON::ParserError' do
        expect { subject }.to raise_error(JSON::ParserError)
      end
    end

    context 'with invalid logs JSON' do
      subject { described_class.call(sample_prices_json, 'invalid json') }

      it 'raises JSON::ParserError' do
        expect { subject }.to raise_error(JSON::ParserError)
      end
    end
  end
end
