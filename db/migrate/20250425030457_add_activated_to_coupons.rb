class AddActivatedToCoupons < ActiveRecord::Migration[7.1]
  def change
    add_column :coupons, :activated, :boolean
  end
end
