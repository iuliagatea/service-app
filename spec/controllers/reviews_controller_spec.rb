# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReviewsController do
  include_context 'initialize'
  let!(:reviews) { create_list(:review, 10, tenant_id: tenant.id, user_id: customer.id) }
  let(:review) { create(:review, tenant_id: tenant.id, user_id: customer.id) }
  describe 'POST #create' do
    let(:create_attributes) { attributes_for(:review) }
    subject { post :create, review: create_attributes, tenant_id: tenant.id, user_id: customer.id }
    it 'saves a new estimate' do
      expect { subject }.to change(Review, :count).by(1)
    end
  end
  describe 'PATCH #update' do
    let(:new_review_title) { 'New name' }
    subject { patch :update, review_id: review.id, title: new_review_title, tenant_id: tenant.id }
    before { review }
    it 'does not save a new estimate' do
      expect { subject }.to change(Review, :count).by(0)
    end
    it 'updates product with new params' do
      subject
      expect(assigns(:review).title).to eq(new_review_title)
    end
  end
  describe 'Delete #destroy' do
    subject { delete :destroy, review_id: review.id, tenant_id: tenant.id }
    before { review }
    it 'deletes the product' do
      expect { subject }.to change(Review, :count).by(-1)
    end
  end
end
