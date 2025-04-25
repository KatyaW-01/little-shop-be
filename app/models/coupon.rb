class Coupon < ApplicationRecord
  belongs_to :merchant
  validates :code, presence: true, uniqueness: true
end