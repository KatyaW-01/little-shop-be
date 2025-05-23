require "rails_helper"
require "spec_helper"

RSpec.describe Coupon, type: :model do
  it {should belong_to :merchant}
  it {is_expected.to validate_presence_of :code}
  it { should have_many :invoices }
  
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
  describe '#check_coupons_on_create' do
    it 'will raise an error if creating an active coupon when count >= 5' do
      merchant = Merchant.create!(name: "Johnson Inc")

      merchant_two = Merchant.create!(name: "Strawberry Fields")

      Coupon.create!(name:"Spring Fling Sale", code: "SPRING20", value: 20.0, value_type: "percent", activated: true, merchant_id: merchant.id)

      Coupon.create!(name:"Ten Dollar Treat", code: "TREAT10", value: 10.0, value_type: "dollar", activated: true, merchant_id: merchant.id)

      Coupon.create!(name:"Welcome Deal", code: "WELCOME15", value: 15.0, value_type: "percent", activated: true, merchant_id: merchant.id)

      Coupon.create!(name: "Buy One Get One Half Off", code: "BOGO50", value: 50.0, value_type: "percent", activated: true, merchant_id: merchant.id)

      Coupon.create!(name: "Flash Sale Special", code: "FLASH5", value: 5.0, value_type: "dollar", activated: true, merchant_id: merchant.id)

      coupon = merchant.coupons.build(name: "Mega Monday", code: "MEGA25", value: 25.0, value_type: "percent", activated: true)
    
      coupon_two = merchant.coupons.build(name: "VIP Exclusive", code: "VIP30", value: 30.0, value_type: "percent", activated: false)

      coupon_three = merchant_two.coupons.build(name: "Happy Hour Discount", code: "HAPPY7", value: 7.0, value_type: "dollar", activated: true)

      expect(coupon.valid?).to eq(false)
      expect(coupon.errors[:activated]).to include("You have reached the maximum number of activated coupons")

      expect(coupon_two.valid?).to eq(true)
      expect(coupon_three.valid?).to eq(true)
    end
  end
  describe '#check_pending_invoices' do
    it 'will raise an error if deactivating a coupon with a pending invoice' do
      merchant = Merchant.create!(name: "Johnson Inc")

      coupon = Coupon.create!(name: "Flash Sale Special", code: "FLASH5", value: 5.0, value_type: "dollar", activated: true, merchant_id: merchant.id)

      customer = Customer.create!(first_name: "Mark", last_name: "Twain")

      Invoice.create!(customer_id: customer.id, merchant_id: merchant.id, status: "packaged", coupon_id: coupon.id)

      Invoice.create!(customer_id: customer.id, merchant_id: merchant.id, status: "shipped", coupon_id: coupon.id)

      result = coupon.update(activated: false)

      expect(result).to be(false)
      expect(coupon.valid?).to be(false)
      expect(coupon.errors[:activated]).to include("Invoices pending, coupon cannot be deactivated")
    end
  end
end