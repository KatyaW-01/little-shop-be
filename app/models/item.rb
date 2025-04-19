class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  validates :merchant, presence: true

  def self.sorted_by_price
    order(:unit_price)
  end
 

end