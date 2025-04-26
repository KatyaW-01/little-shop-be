require "rails_helper"

RSpec.describe "Coupon API", type: :request do
  describe 'GET merchants/:merchant_id/coupons' do
    it 'can fetch all coupons for a merchant' do
      merchant = Merchant.create!(name: "Strawberry Fields")
      merchant_two = Merchant.create!(name: "Johnson Inc")

      Coupon.create!(name:"Spring Fling Sale", code: "SPRING20", value: 20.0, value_type: "percent", activated: false, merchant_id: merchant.id)

      Coupon.create!(name:"Ten Dollar Treat", code: "TREAT10", value: 10.0, value_type: "dollar", activated: true, merchant_id: merchant.id)

      Coupon.create!(name:"Welcome Deal", code: "WELCOME15", value: 15.0, value_type: "percent", activated: true, merchant_id: merchant.id)

      Coupon.create!(name: "Buy One Get One Half Off", code: "BOGO50", value: 50.0, value_type: "percent", activated: true, merchant_id: merchant.id)

      Coupon.create!(name: "Flash Sale Special", code: "FLASH5", value: 5.0, value_type: "dollar", activated: true, merchant_id: merchant_two.id)

      get api_v1_merchant_coupons_path(merchant.id)

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)
      
      data = json[:data]
      attributes = data[0][:attributes]

      expect(data).to be_an(Array)
      expect(data.count).to eq(4)
      expect(attributes[:name]).to eq("Spring Fling Sale")
      expect(attributes[:code]).to eq("SPRING20")
      expect(attributes[:value]).to eq(20.0)
      expect(attributes[:value_type]).to eq("percent")
      expect(attributes[:activated]).to eq(false)
      expect(attributes[:merchant_id]).to eq(merchant.id)
    end
  end
  describe 'Get /api/v1/merchants/:merchant_id/coupons/:id' do
    it 'can fetch a single coupon' do
      merchant = Merchant.create!(name: "Strawberry Fields")

      coupon = Coupon.create!(name:"Spring Fling Sale", code: "SPRING20", value: 20.0, value_type: "percent", activated: false, merchant_id: merchant.id)

      get api_v1_merchant_coupon_path(merchant.id,coupon.id)

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)

      coupons = json[:data]
      attributes = coupons[:attributes]

      expect(coupons).to be_a(Hash)
      expect(attributes[:name]).to eq("Spring Fling Sale")
      expect(attributes[:code]).to eq("SPRING20")
      expect(attributes[:value]).to eq(20.0)
      expect(attributes[:value_type]).to eq("percent")
      expect(attributes[:activated]).to eq(false)
      expect(attributes[:merchant_id]).to eq(merchant.id)
    end
  end
end