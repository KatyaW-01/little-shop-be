class MerchantSerializer
  include JSONAPI::Serializer
  attributes :name
  attributes :coupons_count do |object|
    object.coupons.count
  end
  attributes :invoice_coupon_count do |object|
    object.invoices.where(:coupon_id => !nil).count
  end
end

