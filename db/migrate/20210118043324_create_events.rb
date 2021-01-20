class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :name,            null: false
      t.text :text,              null: false
      t.date   :date,            null: false
      t.string :start_time,      null: false
      t.string :finish_time,     null: false
      
      t.string :postal_code,     null: false
      t.integer :prefecture_id,  null: false
      t.string :city,            null: false
      t.string :house_number,    null: false
      t.string :building

      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
