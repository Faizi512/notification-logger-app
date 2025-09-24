require 'spec_helper'

RSpec.describe NotificationLog do
  let(:log_data) do
    {
      'company' => 'Sharesies',
      'type' => 'sms',
      'country' => 'AU'
    }
  end

  subject { described_class.new(log_data) }

  describe 'initialization' do
    it 'sets company attribute' do
      expect(subject.company).to eq('Sharesies')
    end

    it 'sets type attribute' do
      expect(subject.type).to eq('sms')
    end

    it 'sets country attribute' do
      expect(subject.country).to eq('AU')
    end
  end

  describe 'attributes' do
    it 'provides read-only access to company' do
      expect(subject).to respond_to(:company)
      expect(subject).not_to respond_to(:company=)
    end

    it 'provides read-only access to type' do
      expect(subject).to respond_to(:type)
      expect(subject).not_to respond_to(:type=)
    end

    it 'provides read-only access to country' do
      expect(subject).to respond_to(:country)
      expect(subject).not_to respond_to(:country=)
    end
  end

  describe 'data normalization' do
    let(:log_data) do
      {
        'company' => '  Sharesies  ',
        'type' => ' SMS ',
        'country' => ' au '
      }
    end

    it 'normalizes company by stripping whitespace' do
      expect(subject.company).to eq('Sharesies')
    end

    it 'normalizes type to lowercase' do
      expect(subject.type).to eq('sms')
    end

    it 'normalizes country to uppercase' do
      expect(subject.country).to eq('AU')
    end
  end

  describe 'validation' do
    context 'with nil data' do
      it 'raises error' do
        expect { described_class.new(nil) }.to raise_error("Log data cannot be nil")
      end
    end

    context 'with missing company' do
      let(:log_data) { { 'type' => 'sms', 'country' => 'AU' } }
      
      it 'raises error' do
        expect { described_class.new(log_data) }.to raise_error(/Missing required field: 'company'/)
      end
    end

    context 'with invalid type' do
      let(:log_data) do
        { 'company' => 'Test', 'type' => 'fax', 'country' => 'AU' }
      end
      
      it 'raises error' do
        expect { described_class.new(log_data) }.to raise_error("Invalid notification type: 'fax'. Valid types: sms, email")
      end
    end

    context 'with invalid country' do
      let(:log_data) do
        { 'company' => 'Test', 'type' => 'sms', 'country' => 'USA' }
      end
      
      it 'raises error' do
        expect { described_class.new(log_data) }.to raise_error("Invalid country: 'USA'. Valid countries: AU, NZ, UK")
      end
    end
  end
end
