class CouponWithCountSerializer
  def self.format_coupon(coupon)
    {
      data: {
        id: coupon.id.to_s,
        type: "coupon",
        attributes: {
          name: coupon.name,
          code: coupon.code,
          value: coupon.value,
          value_type: coupon.value_type,
          activated: coupon.activated,
          merchant_id: coupon.merchant_id,
          times_used: coupon.invoices.count
        }
      }
    }
  end
end