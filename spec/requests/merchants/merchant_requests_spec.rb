require 'rails_helper'

RSpec.describe "Merchants API", type: :request do
  describe "POST /api/v1/merchants" do
    # Happy Path
    it "creates a merchant with valid params" do
      merchant_params = { name: "Toys R Us" }

      post "/api/v1/merchants", params: { merchant: merchant_params }

      expect(response).to have_http_status(:created)

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data][:type]).to eq("merchant")
      expect(json[:data][:attributes][:name]).to eq("Toys R Us")
    end

    # Sad Path
    xit "returns 400 if name param is missing" do
      post "/api/v1/merchants", params: {}

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:errors]).to be_a(Array)
      expect(json[:message]).to eq("your query could not be completed")
      expect(json[:errors]).to include("Missing required parameter: name")
    end

    xit "returns 400 if name param is blank" do
      post "/api/v1/merchants", params: { name: "" }

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:errors]).to be_a(Array)
      expect(json[:message]).to eq("your query could not be completed")
      expect(json[:errors]).to include("Missing required parameter: name")
    end
    
  end

  describe "PATCH /api/v1/merchants/:id" do
    it "updates a merchant with valid params" do
      merchant = Merchant.create!(name: "Old Name")
  
      patch "/api/v1/merchants/#{merchant.id}", params: { merchant: { name: "New Name" } }
  
      expect(response).to have_http_status(:ok)
  
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data][:attributes][:name]).to eq("New Name")
    end

    #Sad Path
    xit "returns 404 if merchant does not exist" do
      patch "/api/v1/merchants/999999", params: { merchant: { name: "Whatever" } }

      expect(response.status).to eq(404)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:message]).to eq("your query could not be completed")
      expect(json[:errors]).to include("Could not find merchant with id: 999999")
    end
  end
end