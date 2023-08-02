require 'rails_helper'

RSpec.describe Category, type: :model do
  let(:category) { Category.new(name: "sample") }

  it "有効であること" do
    expect(category).to be_valid
  end

  it "カテゴリー名が空の場合は無効であること" do
    category.name = ""
    expect(category).not_to be_valid
  end
end
