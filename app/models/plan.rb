# frozen_string_literal: true

class Plan
  PLANS = %i[free premium].freeze

  def self.options
    PLANS.map { |plan| [plan.capitalize, plan] }
  end
end
