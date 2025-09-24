require_relative '../lib/notification_app'

# Shared test data for consistent testing across specs
module TestData
  def sample_prices_json
    '[
      {
        "notification_type": "sms",
        "prices": {
          "AU": 0.50,
          "NZ": 0.45,
          "UK": 0.40
        }
      },
      {
        "notification_type": "email",
        "prices": {
          "AU": 0.10,
          "NZ": 0.08,
          "UK": 0.12
        }
      }
    ]'
  end

  def sample_logs_json
    '[
      { "company": "Sharesies",   "type": "sms",   "country": "AU" },
      { "company": "Mighty Ape",   "type": "email", "country": "NZ" },
      { "company": "Sharesies",   "type": "sms",   "country": "NZ" },
      { "company": "Sharesies",   "type": "sms",   "country": "UK" },
      { "company": "Sharesies",   "type": "sms",   "country": "UK" },
      { "company": "Mighty Ape", "type": "email", "country": "NZ" },
      { "company": "Mighty Ape", "type": "sms", "country": "AU" },
      { "company": "TradeMe",   "type": "sms",   "country": "NZ" },
      { "company": "TradeMe",   "type": "email",   "country": "NZ" },
      { "company": "TradeMe",   "type": "email",   "country": "NZ" },
      { "company": "TradeMe",   "type": "sms",   "country": "NZ" }
    ]'
  end
end

RSpec.configure do |config|
  config.include TestData
  
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
