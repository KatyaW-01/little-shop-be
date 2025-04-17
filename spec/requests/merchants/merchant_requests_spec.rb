require 'rails_helper'

RSpec.describe "Merchants API", type: :request do
  describe "POST /api/v1/merchants" do
    # Happy Path
    it "creates a merchant with valid params" do
      merchant_params = { name: "Toys R Us" }

      post "/api/v1/merchants", params: merchant_params

      expect(response).to have_http_status(:created)

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data][:type]).to eq("merchant")
      expect(json[:data][:attributes][:name]).to eq("Toys R Us")
    end

    # Sad Path
    it "returns 400 if name param is missing" do
      post "/api/v1/merchants", params: {}

      expect(response).to have_http_status(:bad_request)

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:message]).to eq("your query could not be completed")
      expect(json[:errors]).to include("Missing required parameter: name")
    end

    it "returns 400 if name param is blank" do
      post "/api/v1/merchants", params: { name: "" }

      expect(response).to have_http_status(:bad_request)

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:message]).to eq("your query could not be completed")
      expect(json[:errors]).to include("Missing required parameter: name")
    end
  end
end