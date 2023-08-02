require 'rails_helper'

RSpec.describe Stock, type: :model do
  let(:user)  { FactoryBot.create(:user) }
  let(:post)  { FactoryBot.create(:post_by_other) }
  let(:stock) { user.stocks.build(post_id: post.id) }

  it "有効であること" do
    expect(stock).to be_valid
  end

  context "無効な場合" do
    it "user_idがnilの時は登録できないこと" do
      stock.user_id = nil
      expect(stock).not_to be_valid
    end

    it "post_idがnilの時は登録できないこと" do
      stock.post_id = nil
      expect(stock).not_to be_valid
    end
  end
end
