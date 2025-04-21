require "rails_helper"

RSpec.describe "Item Search API", type: :request do
  before :each do
    @merchant = Merchant.create!(name: "Searchy Searcher")
    @item1 = Item.create!(name: "Gold Ring", description: "Shiny", unit_price: 200, merchant: @merchant)
    @item2 = Item.create!(name: "Silver Ring", description: "Less shiny", unit_price: 150, merchant: @merchant)
    @item3 = Item.create!(name: "Wooden Spoon", description: "Not shiny", unit_price: 10, merchant: @merchant)
  end

  # Happy Path
  describe "GET /api/v1/items/find" do
    it "returns one item matching the name fragment" do
      get "/api/v1/items/find?name=ring"

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data][:attributes][:name].to eq("Gold Ring")) # Should return alphabetical first
    end

    it "returns one item in price range (min + max)" do
      get "/api/v1/items/find?min_price=100&max_price=200"

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data][:attributes][:name].to eq("Gold Ring"))
    end

    # Sad Path
    it "returns error if no param is passed" do
      get "/api/v1/items/find"

      expect(response.status).to eq(400)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:errors]).to include("name or price range")
    end
  end
end