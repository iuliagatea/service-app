# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TenantCategory, type: :model do
  describe 'Validations' do
    it { should belong_to(:tenant) }
    it { should belong_to(:category) }
  end
end
