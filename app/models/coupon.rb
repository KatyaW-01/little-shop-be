class Coupon < ApplicationRecord

  belongs_to :merchant
  has_many :invoices

  validates :code, presence: true, uniqueness: true
  validate :check_coupon_limit 
  validate :check_coupon_count, on: :update
  validate :check_coupons_on_create, on: :create
  validate :check_pending_invoices, on: :update

  def check_coupon_limit 
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
    self.invoices.each do |invoice|
      if invoice.status == 'packaged' && activated_change_to_be_saved == [true, false]
        errors.add(:activated, "Invoices pending, coupon cannot be deactivated")
        break 
      end
    end
  end

end