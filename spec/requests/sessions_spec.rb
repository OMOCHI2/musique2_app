require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/signup"
      expect(response).to be_successful
      expect(response).to have_http_status(200)
    end
  end

end
