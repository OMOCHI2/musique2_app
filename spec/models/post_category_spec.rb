require 'rails_helper'

RSpec.describe PostCategory, type: :model do
  let(:post)          { FactoryBot.create(:post_by_user) }
  let(:category)      { FactoryBot.create(:daw) }
  let(:post_category) { post.post_categories.build(category_id: category.id) }

  it "有効であること" do
    expect(post_category).to be_valid
  end

  context "無効な場合" do
    it "post_idがnilの時は登録できないこと" do
      post_category.post_id = nil
      expect(post_category).not_to be_valid
    end

    it "category_idがnilの時は登録できないこと" do
      post_category.category_id = nil
      expect(post_category).not_to be_valid
    end
  end
end
