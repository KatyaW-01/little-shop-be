require "rails_helper"

RSpec.describe "Merchant endpoints", type: :request do
  describe 'destroy' do
    it 'deletes a merchant and returns not content' do
      merchant = Merchant.create!(name: "Test Merchant")

      delete "/api/v1/merchants/#{merchant.id}"

      expect(response).to have_http_status(:no_content)
      expect(Merchant.find_by(id: merchant.id)).to be_nil
    end

    # it 'returns a not_found error' do
    #   delete "/api/v1/merchants/99999"

    #   expect(response).to have_http_status(:not_found)

    #   parsed_json = JSON.parse(response.body, symbolize_names: true)
    #   errors = parsed_json[:errors].first

    #   expect(parsed_json[:errors]).to be_an(Array)
    #   expect(errors[:status]).to eq("404")
    #   expect(errors[:message]).to include("Couldn't find Merchant with 'id'=99999")
    # end

    it 'also deletes associated items and accosiated invoice item when merchant is deleted' do 
      merchant = Merchant.create!(name: "Test Cascading")
     
      item1 = merchant.items.create!(name: "Item 1", description: "Born to be deleted", unit_price: 10)
      item2 = merchant.items.create!(name: "Item 2", description: "Second born to be deleted", unit_price: 20)
      customer = Customer.create!(first_name: "Test", last_name: "Customer")
      invoice = Invoice.create!(status: "shipped", customer_id: customer.id, merchant_id: merchant.id)
      invoice_item = item1.invoice_items.create!(invoice: invoice, quantity: 5, unit_price: 100)

      initial_item_count = Item.count
      initial_invoice_item_count = InvoiceItem.count 
      delete "/api/v1/merchants/#{merchant.id}"
      final_item_count = Item.count 
      final_invoice_item_count = InvoiceItem.count

      expect(final_item_count).to eq(initial_item_count - 2)
      expect(final_invoice_item_count).to eq(initial_invoice_item_count - 1)
    end
  end
end