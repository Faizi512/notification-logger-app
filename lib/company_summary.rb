# Aggregates notification count and total cost for a company
class CompanySummary
  attr_reader :company, :notification_count, :cost

  def initialize(company)
    @company = company
    @notification_count = 0
    @cost = 0.0
  end

  def add_notification_cost(notification_cost)
    @notification_count += 1
    @cost += notification_cost
  end

  def to_h
    {
      'company' => @company,
      'notification_count' => @notification_count,
      'cost' => @cost
    }
  end
end
