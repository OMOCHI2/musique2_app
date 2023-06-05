require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "#home" do
    it "responds successfully" do
      get root_path
      expect(response).to be_successful
      expect(response).to have_http_status(200)
    end
  end

  describe "#help" do
    it "responds successfully" do
      get help_path
      expect(response).to be_successful
      expect(response).to have_http_status(200)
    end
  end

  describe "#about" do
    it "responds successfully" do
      get about_path
      expect(response).to be_successful
      expect(response).to have_http_status(200)
    end
  end

  describe "#terms" do
    it "responds successfully" do
      get terms_path
      expect(response).to be_successful
      expect(response).to have_http_status(200)
    end
  end

  describe "#privacy" do
    it "responds successfully" do
      get privacy_path
      expect(response).to be_successful
      expect(response).to have_http_status(200)
    end
  end
end
