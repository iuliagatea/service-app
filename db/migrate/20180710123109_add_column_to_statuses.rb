# frozen_string_literal: true

class AddColumnToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :send_email, :boolean, default: true
  end
end
