require 'rails_helper'

RSpec.describe AuthenticationController, type: :controller do
  describe "POST #login" do
    before(:all) do
      @user = FactoryGirl.create(:user)
    end

    after(:all) do
      @user.delete
    end

    it "returns user's informations when credentials are correct" do
      post :login, params: { email: @user.email, password: 'popsicles'}

      body = JSON.parse(response.body)

      expect(response).to have_http_status(:success)
      expect(body['email']).to eq @user.email
      expect(body['username']).to eq @user.username
    end

    it "returns a generic error message with wrong credentials" do
      post :login, params: { email: @user.email, password: 'popsicles2'}

      body = JSON.parse(response.body)

      expect(response).to have_http_status(:success)
      expect(body['error']).to eq 'Wrong credentials'
    end
  end

  describe "POST #signup" do
    before(:each) do
      @user = FactoryGirl.build(:user)
    end

    after(:all) do
      @user.delete
    end

    it "returns user's informations when signup is successful" do
      post :signup, params: { user: { email: @user.email, username: @user.username, password: 'popsicles'}}

      body = JSON.parse(response.body)

      expect(response).to have_http_status(:success)
      expect(body['email']).to eq @user.email
      expect(body['username']).to eq @user.username
    end

    it "returns an error when parameters are missing" do
      post :signup, params: { user: { email: @user.email, password: 'popsicles'}}
      expect(response).to have_http_status(404)

      post :signup, params: { user: { username: @user.username, password: 'popsicles'}}
      expect(response).to have_http_status(404)
    end
  end

end
