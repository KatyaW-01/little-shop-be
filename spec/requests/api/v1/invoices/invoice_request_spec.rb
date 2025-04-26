require "rails_helper"

RSpec.describe "Invoice endpoints", type: :request do
  describe 'index' do
    it 'returns all invoices for a merchant' do
      merchant = Merchant.create!(name: "Test Merchant")
      customer = Customer.create!(first_name: "Lulu", last_name: "Customer")
      Invoice.create!(status: "shipped", customer_id: customer.id, merchant_id: merchant.id)
      Invoice.create!(status: "packaged", customer_id: customer.id, merchant_id: merchant.id)

      get "/api/v1/merchants/#{merchant.id}/invoices"

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)
      data = json[:data]

      expect(data).to be_an(Array)
      expect(data.count).to eq(2)
      expect(data[0][:attributes][:status]).to eq("shipped")
      expect(data[1][:attributes][:status]).to eq("packaged")
    end
    it 'returns all invoices for given merchant by its status' do
      merchant = Merchant.create!(name: "Test Merchant")
      customer = Customer.create!(first_name: "Lulu", last_name: "Customer")
      shipped_invoice = Invoice.create!(status: "shipped", customer_id: customer.id, merchant_id: merchant.id)
      packaged_invoice = Invoice.create!(status: "packaged", customer_id: customer.id, merchant_id: merchant.id)

      get "/api/v1/merchants/#{merchant.id}/invoices?status=shipped"

      expect(response).to be_successful

      data = JSON.parse(response.body, symbolize_names: true)[:data]
      
      expect(data.count).to eq(1)
      expect(data.first[:id]).to eq(shipped_invoice.id.to_s)
      expect(data.first[:attributes][:status]).to eq("shipped")
    end

    it 'returns an empty array if no invoices match the given status' do 
      merchant = Merchant.create!(name: "Test Merchant")
      customer = Customer.create!(first_name: "Lulu", last_name: "Customer")
      shipped_invoice = Invoice.create!(status: "shipped", customer_id: customer.id, merchant_id: merchant.id)
      packaged_invoice = Invoice.create!(status: "packaged", customer_id: customer.id, merchant_id: merchant.id)

      get "/api/v1/merchants/#{merchant.id}/invoices?status=returned"

      expect(response).to be_successful
      
      data = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(data).to eq([])
    end

    it 'returns a bad_request error for invalid status query' do
      merchant = Merchant.create!(name: "Test Merchant")

      get "/api/v1/merchants/#{merchant.id}/invoices?status=invalid_status"

      expect(response.status).to eq(400)

      parsed_json = JSON.parse(response.body, symbolize_names: true)
      

      expect(parsed_json[:errors]).to be_an(Array)
      expect(parsed_json[:message]).to eq("your query could not be completed")
      expect(parsed_json[:errors]).to include("Invalid status.")
    end

    it 'returns a not_found error if merchant does not exist' do
      get "/api/v1/merchants/999999/invoices?status=shipped"

      expect(response).to have_http_status(:not_found)

      parsed_json = JSON.parse(response.body, symbolize_names: true)
      
      expect(parsed_json[:message]).to eq("your query could not be completed")
      expect(parsed_json[:errors]).to be_an(Array)
      expect(parsed_json[:errors]).to include("Couldn't find Merchant with 'id'=999999")
    end
  end
end