# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EstimatesController do
  include_context 'initialize'
  let!(:estimates) { create_list(:estimate, 10) }
  let(:estimate) { create(:estimate) }
  describe 'GET #index' do
    subject { get :index }
    it 'renders a list of estimates' do
      subject
      expect(assigns(:estimates)).to match_array(Estimate.all)
    end
    it { expect(subject).to render_template(:index) }
  end
  describe 'GET #new' do
    subject { get :new }
    it 'assigns values to variables' do
      subject
      expect(assigns(:estimate).id).to be_nil
    end
    it { expect(subject).to render_template(:new) }
  end
  describe 'POST #create' do
    let(:estimate_attributes) { attributes_for(:estimate) }
    subject { post :create, estimate: estimate_attributes }
    it 'saves a new estimate' do
      expect { subject }.to change(Estimate, :count).by(1)
    end
  end
  describe 'GET #show' do
    subject { get :show, id: estimate.id }
    before { estimate }
    it 'assigns values to variables' do
      subject
      expect(assigns(:estimate)).to eq(estimate)
    end
    it { expect(subject).to render_template(:show) }
  end
  describe 'GET #edit' do
    subject { get :edit, id: estimate.id }
    before { estimate }
    it 'assigns values to variables' do
      subject
      expect(assigns(:estimate)).to eq(estimate)
    end
    it { expect(subject).to render_template(:edit) }
  end
  describe 'PATCH #update' do
    let(:new_estimate_name) { 'New name' }
    let(:update_attributes) do
      { name: new_estimate_name }
    end
    subject { patch :update, id: estimate.id, estimate: update_attributes }
    before { estimate }
    it 'does not save a new estimate' do
      expect { subject }.to change(Estimate, :count).by(0)
    end
    it 'updates product with new params' do
      subject
      expect(assigns(:estimate).name).to eq(new_estimate_name)
    end
  end
  describe 'Delete #destroy' do
    subject { delete :destroy, id: estimate.id }
    before { estimate }
    it 'deletes the product' do
      expect { subject }.to change(Estimate, :count).by(-1)
    end
  end
end
