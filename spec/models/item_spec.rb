require "rails_helper"
require "spec_helper"

RSpec.describe Item, type: :model do
  it { should belong_to :merchant }
  it { should have_many(:invoice_items).dependent(:destroy) }

  describe 'dependent destroy' do
    it 'destroys associated invoice_items when item is deleted' do
      merchant = Merchant.create!(name: "Test Merchant")
      item = merchant.items.create!(name: "Test Item", description: "Desc", unit_price: 50)
      customer = Customer.create!(first_name: "John", last_name: "Doe")
      invoice = Invoice.create!(status: "shipped", merchant_id: merchant.id, customer_id: customer.id)
      item.invoice_items.create!(invoice_id: invoice.id, quantity: 1, unit_price: 50)

      initial_invoice_item_count = InvoiceItem.count
      merchant.destroy
      final_invoice_item_count = InvoiceItem.count

      expect(final_invoice_item_count).to eq(initial_invoice_item_count -1)
    end
  end

  describe "sorted by price" do
    it "can sort items by price" do
      merchant = Merchant.create!(name: "Alfanzo")

      item1 = Item.create!(name: "Item Nemo Facere", description: "Description for item 1", unit_price: 42.91, merchant: merchant)
      item2 = Item.create!(name: "Item Provident At", description: "Description for item 2", unit_price: 159.25, merchant: merchant)
      item3 = Item.create!(name: "Item Expedita Aliquam", description: "Description for item 3", unit_price: 687.23, merchant: merchant)
      
      result = Item.sorted_by_price

      expect(result.first).to eq(item1)
      expect(result.last).to eq(item3)
    end
  end
end