# frozen_string_literal: true

class DropReviewsTable < ActiveRecord::Migration
  def change
    drop_table :reviews
  end
end
