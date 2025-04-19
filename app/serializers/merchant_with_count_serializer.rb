class MerchantWithCountSerializer
  include JSONAPI::Serializer
  attributes :name, :item_count
end