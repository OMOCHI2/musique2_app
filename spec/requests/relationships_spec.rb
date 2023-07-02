require 'rails_helper'

RSpec.describe "Relationships", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:other_user) }

  describe "#create" do
    it "成功時に1件増えること" do
      log_in user
      expect {
        post relationships_path, params: { followed_id: other_user.id }
      }.to change(Relationship, :count).by 1
    end

    it "Hotwireでも登録できること" do
      log_in user
      expect {
        post relationships_path(format: :turbo_stream), params: { followed_id: other_user.id }
      }.to change(Relationship, :count).by 1
    end

    context "未ログインの場合" do
      it "ログインページにリダイレクトすること" do
        post relationships_path
        expect(response).to redirect_to login_path
      end

      it "登録できないこと" do
        expect {
          post relationships_path
        }.not_to change(Relationship, :count)
      end
    end
  end

  describe "#destroy" do
    it "成功時に1件減ること" do
      log_in user
      user.follow(other_user)
      relationship = user.active_relationships.find_by(followed_id: other_user.id)
      expect {
        delete relationship_path(relationship)
      }.to change(Relationship, :count).by -1
    end

    it "Hotwireでも削除できること" do
      log_in user
      user.follow(other_user)
      relationship = user.active_relationships.find_by(followed_id: other_user.id)
      expect {
        delete relationship_path(relationship, format: :turbo_stream)
      }.to change(Relationship, :count).by -1
    end
  end
end
