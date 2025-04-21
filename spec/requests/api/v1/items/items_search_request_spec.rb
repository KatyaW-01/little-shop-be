require "rails_helper"

RSpec.describe "Item Search API", type: :request do
  before :each do
    @merchant = Merchant.create!(name: "Searchy Searcher")
    @item1 = Item.create!(name: "Gold Ring", description: "Shiny", unit_price: 200, merchant: @merchant)
    @item2 = Item.create!(name: "Silver Ring", description: "Less shiny", unit_price: 150, merchant: @merchant)
    @item3 = Item.create!(name: "Wooden Spoon", description: "Not shiny", unit_price: 10, merchant: @merchant)
  end

  # Happy Path
  describe "Happy Path GET /api/v1/items/find" do
    it "returns one item matching the name fragment" do
      get "/api/v1/items/find?name=ring"

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data][:attributes][:name]).to eq("Gold Ring") # Should return alphabetical first
    end

    it "returns one item in price range (min + max)" do
      get "/api/v1/items/find?min_price=100&max_price=200"

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data][:attributes][:name]).to eq("Gold Ring")
    end

    it "returns one item at max price" do
      get "/api/v1/items/find?max_price=100"

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data][:attributes][:name]).to eq("Wooden Spoon")
    end

    it "returns one item at min price" do
      get "/api/v1/items/find?min_price=175"

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data][:attributes][:name]).to eq("Gold Ring")
    end
  end

  describe "Sad Path - GET /api/v1/items/find" do
    it "returns error if no param is passed" do
      get "/api/v1/items/find"

      expect(response.status).to eq(400)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:errors].first).to include("name or price range")
    end

    it "returns an error if name and price are both passed" do
      get "/api/v1/items/find?name=ring&min_price=5"

      expect(response.status).to eq(400)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:errors]).to include("Cannot search by name and price simultaneously")
    end

    it "returns an error for negative price" do
      get "/api/v1/items/find?min_price=-5"

      expect(response.status).to eq(400)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:errors].first).to include("must be a non-negative value")
    end
  end

  describe "Happy Path - GET /api/v1/items/find_all" do
    it "returns all matching items by name fragment" do
      get "/api/v1/items/find_all?name=ring"

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)
      
      names = json[:data].map { |item| item[:attributes][:name] }

      expect(names).to include("Gold Ring", "Silver Ring")
      expect(names).not_to include("Wooden Spoon")
    end

    it "returns all items within price range" do
      get "/api/v1/items/find_all?min_price=100&max_price=250"

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data].count).to eq(2)
    end

    it "returns items above the given minimum price" do
      get "/api/v1/items/find_all?min_price=100"

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data].count).to eq(2)
    end

    it "returns items below the given max price" do
      get "/api/v1/items/find_all?max_price=100"

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data].count).to eq(1)
    end

    it "returns an empty array if no match" do
      get "/api/v1/items/find_all?name=NOMATCH"

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data]).to eq([])
    end
  end

  describe "Sad Path - GET /api/v1/items/find_all" do
    it "returns an error for negative max_price" do
      get "/api/v1/items/find_all?max_price=-100"

      expect(response.status).to eq(400)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:errors].first).to include("must be a non-negative value")
    end

    it "returns an error for mixing name and price" do
      get "/api/v1/items/find_all?name=ring&max_price=100"

      expect(response.status).to eq(400)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:errors].first).to include("Cannot search by name and price simultaneously")
    end

    it "returns an error for negative min_price" do
      get "/api/v1/items/find_all?min_price=-1"

      expect(response.status).to eq(400)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:errors].first).to include("must be a non-negative value")
    end
  end
end