class CouponWithCountSerializer
  include JSONAPI:: Serializer
  attributes :name, :code, :value, :value_type, :activated, :merchant_id, :times_used
end