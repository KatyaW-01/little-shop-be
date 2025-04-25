class CreateCoupons < ActiveRecord::Migration[7.1]
  def change
    create_table :coupons do |t|
      t.string :name
      t.string :code
      t.float :value
      t.string :value_type
      t.references :merchant, null: false, foreign_key: true

      t.timestamps
    end
    
    add_index :coupons, :code, unique: true
  end
end
