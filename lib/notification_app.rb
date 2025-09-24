require_relative 'pricing_matrix'
require_relative 'notification_log'
require_relative 'company_summary'
require 'json'

# Main application class that orchestrates the notification cost calculation
class NotificationApp
  def self.call(prices_json, logs_json)
    validate_inputs!(prices_json, logs_json)
    
    pricing_matrix = PricingMatrix.new(prices_json)
    
    # Parse logs and create NotificationLog objects
    logs_data = JSON.parse(logs_json)
    validate_logs_structure!(logs_data)
    notification_logs = logs_data.map { |log_data| NotificationLog.new(log_data) }
    
    # Group logs by company and calculate costs
    company_summaries = {}
    
    notification_logs.each do |log|
      company = log.company
      
      # Initialize company summary if not exists
      company_summaries[company] ||= CompanySummary.new(company)
      
      # Get cost for this notification
      cost = pricing_matrix.cost_for(log.type, log.country)
      
      # Add to company's total
      company_summaries[company].add_notification_cost(cost)
    end
    
    # Convert to array of hashes as expected by Rakefile
    company_summaries.values.map(&:to_h)
  end

  private

  def self.validate_inputs!(prices_json, logs_json)
    raise "Prices JSON cannot be nil" if prices_json.nil?
    raise "Logs JSON cannot be nil" if logs_json.nil?
    raise "Prices JSON cannot be empty" if prices_json.strip.empty?
    raise "Logs JSON cannot be empty" if logs_json.strip.empty?
  end

  def self.validate_logs_structure!(logs_data)
    raise "Logs data must be an array" unless logs_data.is_a?(Array)
  end
end
