require 'rails_helper'

RSpec.describe "Items API", type: :request do
  describe "POST /api/v1/items" do
    it "creates an item with valid params" do
      merchant = Merchant.create!(name: "Target")
      item_params = {
        name: "Toy Car",
        description: "Red hot wheels toy",
        unit_price: 9.99,
        merchant_id: merchant.id
      }

      post "/api/v1/items", params: { item: item_params }

      expect(response).to have_http_status(:created)

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data][:type]).to eq("item")
      expect(json[:data][:attributes][:name]).to eq("Toy Car")
    end
  end

  describe "PATCH /api/v1/items/:id" do
    it "updates an item with valid params" do
      merchant = Merchant.create!(name: "Target")
      item = Item.create!(
        name: "Old Toy",
        description: "Old description",
        unit_price: 4.99,
        merchant_id: merchant.id
      )
  
      patch "/api/v1/items/#{item.id}", params: {
        item: {
          name: "New Toy",
          description: "New description",
          unit_price: 6.49
        }
      }
  
      expect(response).to have_http_status(:ok)
  
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data][:attributes][:name]).to eq("New Toy")
      expect(json[:data][:attributes][:unit_price]).to eq(6.49)
    end
  end
end