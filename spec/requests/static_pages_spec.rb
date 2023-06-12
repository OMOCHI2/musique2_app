require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "#home" do
    it "responds successfully" do
      get root_path
      expect(response).to have_http_status :success
    end
  end

  describe "#help" do
    it "responds successfully" do
      get help_path
      expect(response).to have_http_status :success
    end
  end

  describe "#about" do
    it "responds successfully" do
      get about_path
      expect(response).to have_http_status :success
    end
  end

  describe "#terms" do
    it "responds successfully" do
      get terms_path
      expect(response).to have_http_status :success
    end
  end

  describe "#privacy" do
    it "responds successfully" do
      get privacy_path
      expect(response).to have_http_status :success
    end
  end

  describe "#contact" do
    it "responds successfully" do
      get contact_path
      expect(response).to have_http_status :success
    end
  end
end
