class Coupon < ApplicationRecord

  belongs_to :merchant
  validates :code, presence: true, uniqueness: true
  validate :check_coupon_limit
  validate :check_coupon_count, on: :update
  validate :check_coupons_on_create, on: :create

  def check_coupon_limit
    if activated? && Coupon.where(merchant_id: self.merchant_id, activated: true).count > 5
      errors.add(:activated, "You have reached the maximum number of activated coupons")
    end
  end
  #checks if activated is true and if the count is greater than 5 

  def check_coupon_count #accounts for updating the activated column to true 
    if will_save_change_to_activated? && activated? && Coupon.where(merchant_id: self.merchant_id, activated: true).count >= 5
      errors.add(:activated, "You have reached the maximum number of activated coupons")
    end
  end
  #will_save_change_to_activated checks if the activated column will be changing 

  def check_coupons_on_create
    if self[:activated] && Coupon.where(merchant_id: self.merchant_id, activated: true).count >= 5
      errors.add(:activated, "You have reached the maximum number of activated coupons")
    end
  end
end