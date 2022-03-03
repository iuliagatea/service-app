# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'Validations' do
    it { should belong_to :tenant }
    it { should belong_to :user }
    it { should have_many(:statuses).through(:product_statuses) }
    it { should have_many(:estimates).inverse_of(:product) }
    it { should accept_nested_attributes_for(:user) }
    it { should accept_nested_attributes_for(:estimates) }
  end
end
