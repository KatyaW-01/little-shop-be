class Coupon < ApplicationRecord

  belongs_to :merchant
  validates :code, presence: true, uniqueness: true
  validate :check_coupon_limit # could remove
  validate :check_coupon_count, on: :update
  validate :check_coupons_on_create, on: :create

  validate :check_pending_invoices, on: :update

  def check_coupon_limit #might not be necessary, could remove
    if activated? && Coupon.where(merchant_id: self.merchant_id, activated: true).count >= 5
      errors.add(:activated, "You have reached the maximum number of activated coupons")
    end
  end

  def check_coupon_count 
    if will_save_change_to_activated? && activated? && Coupon.where(merchant_id: self.merchant_id, activated: true).count >= 5
      errors.add(:activated, "You have reached the maximum number of activated coupons")
    end
  end

  def check_coupons_on_create
    if self[:activated] && Coupon.where(merchant_id: self.merchant_id, activated: true).count >= 5
      errors.add(:activated, "You have reached the maximum number of activated coupons")
    end
  end

  def check_pending_invoices
    #if there are pending invoices cannot change activated to false
  end

  def self.item_count
    #count of how many invoices coupon is attached to
  end

end