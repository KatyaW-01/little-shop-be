require "rails_helper"

RSpec.describe "Invoice endpoints", type: :request do
  describe 'index' do
    it 'it returns all invoices for given merchant by its status' do
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
  end
end