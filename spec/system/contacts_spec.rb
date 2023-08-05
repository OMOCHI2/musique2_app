require 'rails_helper'

RSpec.describe "Contacts", type: :system do
  before do
    visit contact_path
  end
  it "正しい操作のときは送信完了画面が表示されること" do
    fill_in "名前",           with: "Test User"
    fill_in "メールアドレス",   with: "test@example.com"
    fill_in "お問い合わせ内容", with: "Test content"
    click_button "確認"
    expect(page).to have_content "この内容で送信します。よろしいですか？"

    click_button "送信"
    expect(page).to have_content "ありがとうございます。お問い合わせ内容を送信しました。"
  end

  it "無効な値を入力したときはエラー領域が表示されていること" do
    fill_in "名前",           with: "Invalid Man"
    fill_in "メールアドレス",   with: "user.invalid.com"
    fill_in "お問い合わせ内容", with: ""
    click_button "確認"

    expect(page).to have_selector "div#error_explanation"
    expect(page).to have_selector "div.field_with_errors"
  end
end
