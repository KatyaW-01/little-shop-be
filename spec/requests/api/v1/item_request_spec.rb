require "rails_helper"

RSpec.describe "Item API", type: :request do
  #happy path
  describe "GET /api/v1/items" do
    it "can fetch all items" do
      merchant1 = Merchant.create!(name: "Merchant One")
    
      Item.create!(name: "Item 1", merchant: merchant1)
      Item.create!(name: "Item 2", merchant: merchant1)
      Item.create!(name: "Item 3", merchant: merchant1)
  
        get "/api/v1/items"
  
        expect(response).to be_successful
  
        json = JSON.parse(response.body, symbolize_names: true)
  
        expect(json[:data].count).to eq(3)
        expect(json[:data].first[:type]).to eq("item")
        expect(json[:data].first[:attributes]).to have_key(:name)
    end
  end
  describe "GET /api/v1/items?sorted=price" do
    it "can sort all items by price" do
      merchant = Merchant.create!(name: "Alfanzo")

      item1 = Item.create!(name: "Item Nemo Facere", unit_price: 42.91, merchant: merchant)
      item2 = Item.create!(name: "Item Provident At", unit_price: 159.25, merchant: merchant)
      item3 = Item.create!(name: "Item Expedita Aliquam", unit_price: 687.23, merchant: merchant)
      

      get "/api/v1/items?sorted=price"

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)

        items = json[:data]
      

        
      
      expect(items[0][:attributes][:unit_price]).to eq(item1.unit_price.to_f)
    end
  end
end