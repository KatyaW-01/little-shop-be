class Coupon < ApplicationRecord
  belongs_to :merchant
  validates :code, presence: true, uniqueness: true
  validate :check_coupon_limit

  def check_coupon_limit
    if activated? && Coupon.where(merchant_id: self.merchant_id, activated: true).count > 5
      errors.add(:activated, "You have reached the maximum number of activated coupons")
    end
  end
  #checks if activated is true and if the count is greater than 5 
end