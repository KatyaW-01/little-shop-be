require "rails_helper"

RSpec.describe "Item endpoints", type: :request do
  describe 'destroy a item' do
    it 'deletes a item and returns not content' do
      merchant = Merchant.create!(name: "Test Merchant")
      item = merchant.items.create!(name: "Test Item", description: "Born to be deleted", unit_price: 10)

      delete "/api/v1/items/#{item.id}"

      expect(response).to have_http_status(:no_content)
      expect(Item.find_by(id: item.id)).to be_nil
    end

    # it 'returns a not_found error' do
    #   delete "/api/v1/items/99999"

    #   expect(response).to have_http_status(:not_found)

    #   parsed_json = JSON.parse(response.body, symbolize_names: true)
    #   errors = parsed_json[:errors].first

    #   expect(errors[:status]).to eq("404")
    #   expect(errors[:message]).to include("Couldn't find Item with 'id'=99999")
    # end

    it 'also deletes associated items and accosiated invoice item when merchant is deleted' do 
      merchant = Merchant.create!(name: "Survivor Merchant")
     
      item = merchant.items.create!(name: "Cascading Test Item", description: "Born to be deleted", unit_price: 10)
      customer = Customer.create!(first_name: "Lulu", last_name: "Customer")
      invoice = Invoice.create!(status: "shipped", customer_id: customer.id, merchant_id: merchant.id)
      invoice_item = item.invoice_items.create!(invoice: invoice, quantity: 5, unit_price: 100)

      initial_item_count = Item.count
      initial_invoice_item_count = InvoiceItem.count
      expect(Merchant.count).to eq(1)
      
      delete "/api/v1/items/#{item.id}"
      
      final_invoice_item_count = InvoiceItem.count
      final_item_count = Item.count

      expect(final_item_count).to eq(initial_item_count - 1)
      expect(final_invoice_item_count).to eq(initial_invoice_item_count - 1)
      expect(Merchant.count).to eq(1)
    end
  end
end