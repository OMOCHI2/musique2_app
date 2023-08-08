class CreateStocks < ActiveRecord::Migration[7.0]
  def change
    create_table :stocks do |t|
      t.references :user, index: true, null: false, foreign_key: true
      t.references :post, index: true, null: false, foreign_key: true

      t.timestamps

      t.index [:user_id, :post_id], unique: true
    end
  end
end
