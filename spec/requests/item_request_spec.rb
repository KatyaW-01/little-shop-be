require "rails_helper"

RSpec.describe "Item endpoints", type: :request do
  describe 'destroy' do
    it 'deletes a item and returns not content' do
      merchant = Merchant.create!(name: "Test Merchant")
      item = merchant.items.create!(name: "Test Item", description: "Born to be deleted", unit_price: 10)

      delete "/api/v1/items/#{item.id}"

      expect(response).to have_http_status(:no_content)
      expect(Item.find_by(id: item.id)).to be_nil
    end

    xit 'returns a not_found error' do
      delete "/api/v1/items/99999"

      expect(response).to have_http_status(:not_found)

      parsed_json = JSON.parse(response.body, symbolize_names: true)
      errors = parsed_json[:errors].first

      expect(parsed_json[:errors]).to be_an(Array)
      expect(errors[:status]).to eq("404")
      expect(errors[:message]).to include("Couldn't find Item with 'id'=99999")
    end

    it 'also deletes associated items and accosiated invoice item when merchant is deleted' do 
      merchant = Merchant.create!(name: "Survivor Merchant")
     
      item = merchant.items.create!(name: "Cascading Test Item", description: "Born to be deleted", unit_price: 10)
      customer = Customer.create!(first_name: "Lulu", last_name: "Customer")
      invoice = Invoice.create!(status: "shipped", customer_id: customer.id, merchant_id: merchant.id)
      invoice_item = item.invoice_items.create!(invoice: invoice, quantity: 5, unit_price: 100)
      transaction = invoice.transactions.create!(credit_card_number: "1234567890123456", result: "success")

      expect(Invoice.find_by(id: invoice.id)).to_not be_nil
      expect(Transaction.find_by(id: transaction.id)).to_not be_nil

      expect(InvoiceItem.find_by(id: invoice_item.id)).to_not be_nil
      expect(Item.find_by(id: item.id)).to_not be_nil
      expect(Merchant.count).to eq(1)
      
      delete "/api/v1/items/#{item.id}"
      
      expect(response).to have_http_status(:no_content)
      expect(Transaction.find_by(id: transaction.id)).to_not be_nil
      expect(Invoice.find_by(id: invoice.id)).to_not be_nil

      expect(Item.find_by(id: item.id)).to be_nil
      expect(InvoiceItem.find_by(id: invoice_item.id)).to be_nil
      expect(Merchant.count).to eq(1)
    end
  end
end