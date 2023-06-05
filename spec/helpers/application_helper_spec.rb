require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "#full_title" do
    it "引数が渡されている場合に動的な表示となること" do
      expect(full_title("hoge")).to eq "hoge - Musique"
    end

    it "引数が空白の場合に動的な表示となること" do
      expect(full_title("")).to eq "Musique"
    end

    it "引数がnilの場合に動的な表示となること" do
      expect(full_title(nil)).to eq "Musique"
    end
  end
end
