require "rails_helper"

RSpec.describe "Merchant endpoints", type: :request do
  describe 'destroy' do
    it 'deletes a merchant and returns not content' do
      merchant = Merchant.create!(name: "Test Merchant")

      delete "/api/v1/merchants/#{merchant.id}"

      expect(response).to have_http_status(:no_content)
      expect(Merchant.find_by(id: merchant.id)).to be_nil
    end

    xit 'returns a not_found error' do
      delete "/api/v1/merchants/99999"

      expect(response).to have_http_status(:not_found)

      parsed_json = JSON.parse(response.body, symbolize_names: true)
      errors = parsed_json[:errors].first

      expect(parsed_json[:errors]).to be_an(Array)
      expect(errors[:status]).to eq("404")
      expect(errors[:message]).to include("Couldn't find Merchant with 'id'=99999")
    end

    it 'also deletes associated items and accosiated invoice item when merchant is deleted' do
      merchant = Merchant.create!(name: "Test Cascading")
     
      item1 = merchant.items.create!(name: "Item 1", description: "Born to be deleted", unit_price: 10)
      item2 = merchant.items.create!(name: "Item 2", description: "Second born to be deleted", unit_price: 20)
      customer = Customer.create!(first_name: "Test", last_name: "Customer")
      invoice = Invoice.create!(status: "shipped", customer_id: customer.id, merchant_id: merchant.id)
      invoice_item = item1.invoice_items.create!(invoice: invoice, quantity: 5, unit_price: 100)
      transaction = invoice.transactions.create!(credit_card_number: "1234567890123456", result: "success")

      expect(Merchant.find_by(id: merchant.id)).to_not be_nil
      expect(Invoice.find_by(id: invoice.id)).to_not be_nil
      expect(Transaction.find_by(id: transaction.id)).to_not be_nil
      expect(InvoiceItem.find_by(id: invoice_item.id)).to_not be_nil
      expect(Item.find_by(id: item1.id)).to_not be_nil
      expect(Item.find_by(id: item2.id)).to_not be_nil

      delete "/api/v1/merchants/#{merchant.id}"

      expect(response).to have_http_status(:no_content)
      expect(Merchant.find_by(id: merchant.id)).to be_nil
      expect(Invoice.find_by(id: invoice.id)).to be_nil
      expect(Transaction.find_by(id: transaction.id)).to be_nil
      expect(Item.find_by(id: item1.id)).to be_nil
      expect(Item.find_by(id: item2.id)).to be_nil
      expect(InvoiceItem.find_by(id: invoice_item.id)).to be_nil
    end
  end
end