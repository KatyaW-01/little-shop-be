require "rails_helper"
require "spec_helper"

RSpec.describe Coupon, type: :model do
  it {should belong_to :merchant}
  it {is_expected.to validate_presence_of :code}
  
  describe '#check_coupon_limit' do
    it 'will raise an error if a merchant has more than 5 activated coupons' do
      merchant = Merchant.create!(name: "Johnson Inc")

      merchant_two = Merchant.create!(name: "Strawberry Fields")

      Coupon.create!(name:"Spring Fling Sale", code: "SPRING20", value: 20.0, value_type: "percent", activated: true, merchant_id: merchant.id)

      Coupon.create!(name:"Ten Dollar Treat", code: "TREAT10", value: 10.0, value_type: "dollar", activated: true, merchant_id: merchant.id)

      Coupon.create!(name:"Welcome Deal", code: "WELCOME15", value: 15.0, value_type: "percent", activated: true, merchant_id: merchant.id)

      Coupon.create!(name: "Buy One Get One Half Off", code: "BOGO50", value: 50.0, value_type: "percent", activated: true, merchant_id: merchant.id)

      Coupon.create!(name: "Flash Sale Special", code: "FLASH5", value: 5.0, value_type: "dollar", activated: true, merchant_id: merchant.id)

      coupon = Coupon.create(name: "Mega Monday", code: "MEGA25", value: 25.0, value_type: "percent", activated: true, merchant_id: merchant.id)

      coupon_two = Coupon.create(name: "VIP Exclusive", code: "VIP30", value: 30.0, value_type: "percent", activated: false, merchant_id: merchant.id)

      coupon_three = Coupon.create(name: "Happy Hour Discount", code: "HAPPY7", value: 7.0, value_type: "dollar", activated: true, merchant_id: merchant_two.id)

      expect(coupon.valid?).to eq(false)
      expect(coupon.errors[:activated]).to include("You have reached the maximum number of activated coupons")

      expect(coupon_two.valid?).to eq(true)
      expect(coupon_three.valid?).to eq(true)
    end
  end
  describe '#check_coupon_count' do
    it 'will raise an error if coupon is updated to activated when count >=5' do
      merchant = Merchant.create!(name: "The Chocolate Farm")

      Coupon.create!(name:"Spring Fling Sale", code: "SPRING20", value: 20.0, value_type: "percent", activated: true, merchant_id: merchant.id)

      Coupon.create!(name:"Ten Dollar Treat", code: "TREAT10", value: 10.0, value_type: "dollar", activated: true, merchant_id: merchant.id)

      Coupon.create!(name:"Welcome Deal", code: "WELCOME15", value: 15.0, value_type: "percent", activated: true, merchant_id: merchant.id)

      Coupon.create!(name: "Buy One Get One Half Off", code: "BOGO50", value: 50.0, value_type: "percent", activated: true, merchant_id: merchant.id)

      Coupon.create!(name: "Flash Sale Special", code: "FLASH5", value: 5.0, value_type: "dollar", activated: true, merchant_id: merchant.id)

      coupon = Coupon.create(name: "Happy Hour Discount", code: "HAPPY7", value: 7.0, value_type: "dollar", activated: false, merchant_id: merchant.id)

      result = coupon.update(activated: true)

      expect(result).to be(false)
      expect(coupon.valid?).to be(false)
      expect(coupon.errors[:activated]).to include("You have reached the maximum number of activated coupons")
    end
  end
  describe '#check_coupon_count' do
    it 'will raise an error if creating an active coupon when count >= 5' do
      merchant = Merchant.create!(name: "Johnson Inc")

      merchant_two = Merchant.create!(name: "Strawberry Fields")

      Coupon.create!(name:"Spring Fling Sale", code: "SPRING20", value: 20.0, value_type: "percent", activated: true, merchant_id: merchant.id)

      Coupon.create!(name:"Ten Dollar Treat", code: "TREAT10", value: 10.0, value_type: "dollar", activated: true, merchant_id: merchant.id)

      Coupon.create!(name:"Welcome Deal", code: "WELCOME15", value: 15.0, value_type: "percent", activated: true, merchant_id: merchant.id)

      Coupon.create!(name: "Buy One Get One Half Off", code: "BOGO50", value: 50.0, value_type: "percent", activated: true, merchant_id: merchant.id)

      Coupon.create!(name: "Flash Sale Special", code: "FLASH5", value: 5.0, value_type: "dollar", activated: true, merchant_id: merchant.id)

      coupon = merchant.coupons.build(name: "Mega Monday", code: "MEGA25", value: 25.0, value_type: "percent", activated: true)
      #build returns a new object that has not been saved yet
      coupon_two = merchant.coupons.build(name: "VIP Exclusive", code: "VIP30", value: 30.0, value_type: "percent", activated: false)

      coupon_three = merchant_two.coupons.build(name: "Happy Hour Discount", code: "HAPPY7", value: 7.0, value_type: "dollar", activated: true)

      expect(coupon.valid?).to eq(false)
      expect(coupon.errors[:activated]).to include("You have reached the maximum number of activated coupons")

      expect(coupon_two.valid?).to eq(true)
      expect(coupon_three.valid?).to eq(true)
    end
  end
end