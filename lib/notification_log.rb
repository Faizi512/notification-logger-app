# Represents a single notification log entry
class NotificationLog
  VALID_TYPES = %w[sms email].freeze
  VALID_COUNTRIES = %w[AU NZ UK].freeze
  
  attr_reader :company, :type, :country

  def initialize(log_data)
    validate_log_data!(log_data)
    
    @company = log_data['company'].strip
    @type = log_data['type'].strip.downcase
    @country = log_data['country'].strip.upcase
    
    validate_values!
  end

  private

  def validate_log_data!(data)
    raise "Log data cannot be nil" if data.nil?
    raise "Log data must be a hash" unless data.is_a?(Hash)
    
    %w[company type country].each do |field|
      value = data[field]
      raise "Missing required field: '#{field}'" if value.nil?
      raise "Field '#{field}' cannot be empty" if value.to_s.strip.empty?
    end
  end

  def validate_values!
    unless VALID_TYPES.include?(@type)
      raise "Invalid notification type: '#{@type}'. Valid types: #{VALID_TYPES.join(', ')}"
    end
    
    unless VALID_COUNTRIES.include?(@country)
      raise "Invalid country: '#{@country}'. Valid countries: #{VALID_COUNTRIES.join(', ')}"
    end
  end
end
