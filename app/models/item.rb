class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items


  # validates :name, :description, :unit_price, :merchant_id, presence: true

  validates :merchant, presence: true
end