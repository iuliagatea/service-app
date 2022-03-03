# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductStatus, type: :model do
  describe 'Validations' do
    it { should belong_to(:status) }
    it { should belong_to(:product) }
  end
end
