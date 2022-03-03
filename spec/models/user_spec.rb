# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    it { should have_one(:member) }
    it { should have_many(:products) }
    it { should have_many(:reviews) }
  end
end
