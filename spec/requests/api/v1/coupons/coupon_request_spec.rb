require "rails_helper"

RSpec.describe "Coupon API", type: :request do
  describe 'GET merchants/:merchant_id/coupons' do
    it 'can fetch all coupons for a merchant' do
      merchant = Merchant.create!(name: "Strawberry Fields")
      merchant_two = Merchant.create!(name: "Johnson Inc")

      Coupon.create!(
        name:"Spring Fling Sale", 
        code: "SPRING20", 
        value: 20.0, 
        value_type: "percent", 
        activated: false, 
        merchant_id: merchant.id)

      Coupon.create!(
        name:"Ten Dollar Treat", 
        code: "TREAT10", 
        value: 10.0, 
        value_type: "dollar", 
        activated: true, 
        merchant_id: merchant.id)

      Coupon.create!(
        name:"Welcome Deal", 
        code: "WELCOME15", 
        value: 15.0, 
        value_type: "percent", 
        activated: true, 
        merchant_id: merchant.id)

      Coupon.create!(
        name: "Buy One Get One Half Off", 
        code: "BOGO50", 
        value: 50.0, 
        value_type: "percent", 
        activated: true, 
        merchant_id: merchant.id)

      Coupon.create!(
        name: "Flash Sale Special", 
        code: "FLASH5", 
        value: 5.0, 
        value_type: "dollar", 
        activated: true, 
        merchant_id: merchant_two.id)

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
  describe 'GET /api/v1/merchants/:merchant_id/coupons/:id' do
    it 'can fetch a single coupon' do
      merchant = Merchant.create!(name: "Strawberry Fields")

      coupon = Coupon.create!(
        name:"Spring Fling Sale", 
        code: "SPRING20", 
        value: 20.0, 
        value_type: "percent", 
        activated: false, 
        merchant_id: merchant.id)

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
  describe 'POST /api/v1/merchants/:merchant_id/coupons' do
    it 'can create a coupon for a merchant' do
      merchant = Merchant.create!(name: "Johnson Inc")

      coupon_params = {
        name: "Buy One Get One Half Off", 
        code: "BOGO50", 
        value: 50.0, 
        value_type: "percent", 
        activated: true, 
        merchant_id: merchant.id
      }

      post api_v1_merchant_coupons_path(merchant.id), params: {coupon: coupon_params}

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)

      coupon = json[:data]
      attributes = coupon[:attributes]

      expect(coupon).to be_a(Hash)
      expect(attributes[:name]).to eq("Buy One Get One Half Off")
      expect(attributes[:code]).to eq("BOGO50")
      expect(attributes[:value]).to eq(50.0)
      expect(attributes[:value_type]).to eq("percent")
      expect(attributes[:activated]).to eq(true)
      expect(attributes[:merchant_id]).to eq(merchant.id)
    end
  end
  describe 'PATCH /api/v1/merchants/:merchant_id/coupons/:id' do
    it 'can activate or deactivate a coupon' do
      merchant = Merchant.create!(name: "Target")

      coupon = Coupon.create!(
        name:"Ten Dollar Treat", 
        code: "TREAT10", 
        value: 10.0, 
        value_type: "dollar", 
        activated: true, 
        merchant_id: merchant.id)

      patch "/api/v1/merchants/#{merchant.id}/coupons/#{coupon.id}", params: {
        coupon: {
          activated: false
        }
      }

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)

      coupon_data = json[:data]
      attributes = coupon_data[:attributes]

      expect(attributes[:activated]).to eq(false)
      expect(coupon.activated).to_not eq(attributes[:activated])
    end
  end
  describe 'GET merchants/:merchant_id/coupons?status=active' do
    it 'can filter coupons by active status' do
      merchant = Merchant.create!(name: "Strawberry Fields")

      Coupon.create!(
        name:"Spring Fling Sale", 
        code: "SPRING20", 
        value: 20.0, 
        value_type: "percent", 
        activated: false, 
        merchant_id: merchant.id)

      Coupon.create!(
        name:"Ten Dollar Treat", 
        code: "TREAT10", 
        value: 10.0, 
        value_type: "dollar", 
        activated: true, 
        merchant_id: merchant.id)

      Coupon.create!(
        name:"Welcome Deal", 
        code: "WELCOME15", 
        value: 15.0, 
        value_type: "percent", 
        activated: true, 
        merchant_id: merchant.id)
      
      get "/api/v1/merchants/#{merchant.id}/coupons?status=active"

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)
      
      data = json[:data]
    
      expect(data).to be_an(Array)
      expect(data.count).to eq(2)
      expect(data[0][:attributes][:name]).to eq("Ten Dollar Treat")
      expect(data[0][:attributes][:activated]).to eq(true)
      expect(data[1][:attributes][:name]).to eq("Welcome Deal")
      expect(data[1][:attributes][:activated]).to eq(true)
    end
  end
  describe 'GET merchants/:merchant_id/coupons?status=inactive' do
    it 'can filter coupons by inactive status' do
      merchant = Merchant.create!(name: "Strawberry Fields")

      Coupon.create!(
        name:"Spring Fling Sale", 
        code: "SPRING20", 
        value: 20.0, 
        value_type: "percent", 
        activated: false, 
        merchant_id: merchant.id)

      Coupon.create!(
        name:"Ten Dollar Treat", 
        code: "TREAT10", 
        value: 10.0, 
        value_type: "dollar", 
        activated: true, 
        merchant_id: merchant.id)

      Coupon.create!(
        name:"Welcome Deal", 
        code: "WELCOME15", 
        value: 15.0, 
        value_type: "percent", 
        activated: true, 
        merchant_id: merchant.id)
      
      get "/api/v1/merchants/#{merchant.id}/coupons?status=inactive"

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)
      
      data = json[:data]
    
      expect(data).to be_an(Array)
      expect(data.count).to eq(1)
      expect(data[0][:attributes][:name]).to eq("Spring Fling Sale")
      expect(data[0][:attributes][:activated]).to eq(false)
    end
  end
  describe 'sad paths and edge cases' do
    it 'will gracefully handle if a coupon code is not unique' do
      merchant = Merchant.create!(name: "Johnson Inc")

      Coupon.create(
        name:"Welcome Deal", 
        code: "BOGO50", 
        value: 15.0, 
        value_type: "percent", 
        activated: true, 
        merchant_id: merchant.id
      )

      coupon_params = {
        name: "Buy One Get One Half Off", 
        code: "BOGO50", 
        value: 50.0, 
        value_type: "percent", 
        activated: true, 
        merchant_id: merchant.id
      }

      post api_v1_merchant_coupons_path(merchant.id), params: {coupon: coupon_params}

      expect(response).to_not be_successful
      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:message]).to eq("your query could not be completed")
      expect(data[:errors]).to be_a(Array)
      expect(data[:errors]).to include("Validation failed: Code has already been taken")
    end
    it 'will gracefully handle if a merchant already has 5 active coupons' do
      merchant = Merchant.create!(name: "Strawberry Fields")

      Coupon.create!(
        name:"Spring Fling Sale", 
        code: "SPRING20", 
        value: 20.0, 
        value_type: "percent", 
        activated: true, 
        merchant_id: merchant.id)

      Coupon.create!(
        name:"Ten Dollar Treat", 
        code: "TREAT10", 
        value: 10.0, 
        value_type: "dollar", 
        activated: true, 
        merchant_id: merchant.id)

      Coupon.create!(
        name:"Welcome Deal", 
        code: "WELCOME15", 
        value: 15.0, 
        value_type: "percent", 
        activated: true, 
        merchant_id: merchant.id)

      Coupon.create!(
        name: "Buy One Get One Half Off", 
        code: "BOGO50", 
        value: 50.0, 
        value_type: "percent", 
        activated: true, 
        merchant_id: merchant.id)

      Coupon.create!(
        name: "Flash Sale Special", 
        code: "FLASH5", 
        value: 5.0, 
        value_type: "dollar", 
        activated: true, 
        merchant_id: merchant.id)

      coupon_params = {
      name: "Summer Discount", 
      code: "SUMMER10", 
      value: 10.0, 
      value_type: "percent", 
      activated: true, 
      merchant_id: merchant.id}

      post api_v1_merchant_coupons_path(merchant.id), params: {coupon: coupon_params}

      expect(response).to_not be_successful
      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:message]).to eq("your query could not be completed")
      expect(data[:errors]).to be_a(Array)
      expect(data[:errors]).to include("Validation failed: Activated You have reached the maximum number of activated coupons")
    end
  end
end