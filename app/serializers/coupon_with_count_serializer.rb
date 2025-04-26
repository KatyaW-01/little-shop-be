class CouponWithCountSerializer
  include JSONAPI:: Serializer
  attributes :name, :code, :value, :value_type, :activated, :merchant_id
  attribute :times_used do |object|
    object.invoices.count
  end
end