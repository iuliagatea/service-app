# frozen_string_literal: true

class Review < ActiveRecord::Base
  belongs_to :tenant
  belongs_to :user
end
