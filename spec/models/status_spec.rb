# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Status, type: :model do
  describe 'Validations' do
    it { should belong_to(:tenant) }
    it { should have_many(:product_statuses) }
    it { should have_many(:products).through(:product_statuses) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:tenant_id) }
  end
end
