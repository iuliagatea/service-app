# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'Validations' do
    it { should have_many(:tenants) }
    it { should have_many(:tenants).through(:tenant_categories) }
  end
end
