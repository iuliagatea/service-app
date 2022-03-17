# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tenant, type: :model do
  describe 'Validations' do
    it { should have_many(:members) }
    it { should have_many(:statuses) }
    it { should have_many(:products) }
    it { should have_many(:estimates) }
    it { should have_many(:tenant_categories) }
    it { should have_many(:categories).through(:tenant_categories) }
    it { should have_many(:reviews) }
    it { should have_one(:payment) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end
