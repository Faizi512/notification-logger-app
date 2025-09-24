require 'spec_helper'

RSpec.describe CompanySummary do
  subject { described_class.new('Sharesies') }

  describe 'initialization' do
    it 'sets company name' do
      expect(subject.company).to eq('Sharesies')
    end

    it 'initializes notification count to 0' do
      expect(subject.notification_count).to eq(0)
    end

    it 'initializes cost to 0.0' do
      expect(subject.cost).to eq(0.0)
    end
  end

  describe '#add_notification_cost' do
    it 'increments notification count' do
      expect { subject.add_notification_cost(0.50) }.to change { subject.notification_count }.from(0).to(1)
    end

    it 'adds to total cost' do
      expect { subject.add_notification_cost(0.50) }.to change { subject.cost }.from(0.0).to(0.50)
    end

    it 'handles multiple notifications' do
      subject.add_notification_cost(0.50)
      subject.add_notification_cost(0.45)
      
      expect(subject.notification_count).to eq(2)
      expect(subject.cost).to eq(0.95)
    end
  end

  describe '#to_h' do
    before do
      subject.add_notification_cost(0.50)
      subject.add_notification_cost(0.45)
    end

    it 'returns hash with correct structure' do
      result = subject.to_h
      
      expect(result).to eq({
        'company' => 'Sharesies',
        'notification_count' => 2,
        'cost' => 0.95
      })
    end

    it 'returns hash with string keys' do
      result = subject.to_h
      
      expect(result.keys).to all(be_a(String))
    end
  end
end
