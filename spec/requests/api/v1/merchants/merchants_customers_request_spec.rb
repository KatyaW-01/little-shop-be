require 'rails_helper'

RSpec.describe "MerchantsCustomers API", type: :request do
  describe "GET /api/v1/merchants/:merchant_id/customers" do
    it "returns all customers for a valid merchant" do
      merchant = Merchant.create!(name: "Merchant With Customers")
      customer_1 = Customer.create!(first_name: "Jim", last_name: "Beam")
      customer_2 = Customer.create!(first_name: "Sarah", last_name: "Connor")
      invoice_1 = Invoice.create!(merchant_id: merchant.id, customer_id: customer_1.id, status: "shipped")
      invoice_2 = Invoice.create!(merchant_id: merchant.id, customer_id: customer_2.id, status: "shipped")

      get "/api/v1/merchants/#{merchant.id}/customers"

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data].count).to eq(2)
      expect(json[:data].first[:type]).to eq("customer")
      expect(json[:data].first[:attributes]).to have_key(:first_name)
      expect(json[:data].first[:attributes]).to have_key(:last_name)
    end

    # Sad Path
    it "returns 404 if merchant not found" do
      get "/api/v1/merchants/999999/customers"

      expect(response.status).to eq(404)

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:message]).to eq("your query could not be completed")
      expect(json[:errors]).to include("Couldn't find Merchant with 'id'=999999")
    end
  end
end