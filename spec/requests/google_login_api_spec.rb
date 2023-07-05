require 'rails_helper'

RSpec.describe "GoogleLoginApis", type: :request do
  describe "GET /callback" do
    it "returns http success" do
      get "/google_login_api/callback"
      expect(response).to redirect_to root_path
    end
  end

end
