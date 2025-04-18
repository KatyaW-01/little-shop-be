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
end