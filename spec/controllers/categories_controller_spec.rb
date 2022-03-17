# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CategoriesController do
  include_context 'initialize'
  before do
    admin_user.email = 'fixit.app2@gmail.com'
    admin_user.save!
  end
  let!(:categories) { create_list(:category, 10) }
  let(:category) { create(:category) }
  describe 'GET #index' do
    subject { get :index }
    it 'renders a list of categories' do
      subject
      expect(assigns(:categories)).to match(Category.all)
    end
    it { expect(subject).to render_template(:index) }
  end
  describe 'GET #new' do
    subject { get :new }
    it 'assigns values to variables' do
      subject
      expect(assigns(:category).id).to be_nil
    end
    it { expect(subject).to render_template(:new) }
  end
  describe 'POST #create' do
    let(:create_attributes) { attributes_for(:category) }
    subject { post :create, category: create_attributes }
    it 'saves a new category' do
      expect { subject }.to change(Category, :count).by(1)
    end
  end
  describe 'GET #show' do
    subject { get :show, id: category.id }
    before { category }
    it 'assigns values to variables' do
      subject
      expect(assigns(:category)).to eq(category)
    end
    it { expect(subject).to render_template(:show) }
  end
  describe 'GET #edit' do
    subject { get :edit, id: category.id }
    before { category }
    it 'assigns values to variables' do
      subject
      expect(assigns(:category)).to eq(category)
    end
    it { expect(subject).to render_template(:edit) }
  end
  describe 'PATCH #update' do
    let(:new_category_name) { 'New name' }
    let(:update_attributes) do
      { name: new_category_name }
    end
    subject { patch :update, id: category.id, category: update_attributes }
    before { category }
    it 'does not save a new category' do
      expect { subject }.to change(Category, :count).by(0)
    end
    it 'updates category with new params' do
      subject
      expect(assigns(:category).name).to eq(new_category_name)
    end
  end
  describe 'Delete #destroy' do
    subject { delete :destroy, id: category.id }
    before { category }
    it 'deletes the product' do
      expect { subject }.to change(Category, :count).by(-1)
    end
  end
end
