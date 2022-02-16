# frozen_string_literal: true

json.array! @estimates, partial: 'estimates/estimate', as: :estimate
