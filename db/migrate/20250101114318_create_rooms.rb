class CreateRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :rooms do |t|
      t.string :name
      t.text :description
      t.integer :price, null: false, default: 0 # 料金カラムを追加（必要に応じて）
      t.string :address                      # 住所カラムを追加（必要に応じて）

      t.timestamps # created_at と updated_at を自動生成
    end
  end
end
