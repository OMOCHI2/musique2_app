require 'rails_helper'

RSpec.describe Relationship, type: :model do
  describe "バリデーションの検証" do
    let(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:other_user) }
    let(:relationship) { user.active_relationships.build(followed_id: other_user.id) }

    it "有効であること" do
      expect(relationship).to be_valid
    end

    context "無効な場合" do
      it "follower_idがnilの時は登録できないこと" do
        relationship.follower_id = nil
        expect(relationship).not_to be_valid
      end

      it "followed_idがnilの時は登録できないこと" do
        relationship.followed_id = nil
        expect(relationship).not_to be_valid
      end
    end
  end
end
