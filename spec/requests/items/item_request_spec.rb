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

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data][:type]).to eq("item")
      expect(json[:data][:attributes][:name]).to eq("Toy Car")
      expect(json[:data][:attributes][:description]).to eq("Red hot wheels toy")
      expect(json[:data][:attributes][:unit_price]).to eq(9.99)
      expect(json[:data][:attributes][:merchant_id]).to eq(merchant.id)
    end

    #Sad Path
    xit "returns 400 if any param is missing" do
      post "/api/v1/items", params: { item: { name: "Incomplete" } }

      expect(response.status).to eq(400)

      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:message]).to eq("your query could not be completed")
      expect(json[:errors]).to be_a(Array)
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
  
      expect(response).to be_successful
  
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data][:attributes][:name]).to eq("New Toy")
      expect(json[:data][:attributes][:unit_price]).to eq(6.49)
      expect(json[:data][:attributes][:description]).to eq("New description")
    end

    # Sad Path
    xit "returns 404 if item does not exist" do
      patch "/api/v1/items/999999", params: {
        item: { name: "Doesn't Matter" }
      }

      expect(response.status).to eq(404)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:message]).to eq("your query could not be completed")
      expect(json[:errors]).to include("Could not find item with id: 999999")
    end
  end
end