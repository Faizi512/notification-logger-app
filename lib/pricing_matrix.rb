require 'json'

# Handles pricing data for notifications by type and country
class PricingMatrix
  def initialize(prices_json)
    @pricing_data = JSON.parse(prices_json)
    @prices = build_price_lookup
  end

  def cost_for(type, country)
    validate_type_and_country!(type, country)
    
    price = @prices.dig(type, country)
    raise "No price found for '#{type}' notifications in '#{country}'" if price.nil?
    
    price
  end

  private

  def build_price_lookup
    lookup = {}
    @pricing_data.each do |price_entry|
      validate_price_entry!(price_entry)
      type = price_entry['notification_type']
      lookup[type] = price_entry['prices']
    end
    lookup
  end

  def validate_price_entry!(entry)
    raise "Invalid price entry: missing 'notification_type'" unless entry['notification_type']
    raise "Invalid price entry: missing 'prices'" unless entry['prices']
    raise "Invalid price entry: 'prices' must be a hash" unless entry['prices'].is_a?(Hash)
  end

  def validate_type_and_country!(type, country)
    raise "Notification type cannot be nil or empty" if type.nil? || type.strip.empty?
    raise "Country cannot be nil or empty" if country.nil? || country.strip.empty?
  end
end
