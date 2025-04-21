require "rails_helper"
require "spec_helper"

RSpec.describe Merchant, type: :model do
  it { should have_many(:items).dependent(:destroy) }
  it { should have_many(:invoices).dependent(:destroy) }

  describe 'dependent destroy' do
    it 'destroys associated items when merchant is deleted' do
      merchant = Merchant.create!(name: "Test Merchant")
      merchant.items.create!(name: "Item 1", description: "Desc", unit_price: 100)
      merchant.items.create!(name: "Item 2", description: "Desc", unit_price: 200)

      initial_item_count = Item.count
      merchant.destroy
      final_item_count = Item.count

      expect(final_item_count).to eq(initial_item_count -2)
    end

    it 'destroys associated invoices when merchant is deleted' do
      merchant = Merchant.create!(name: "Test Merchant")
      customer = Customer.create!(first_name: "Jane", last_name: "Doe")
      merchant.invoices.create!(status: "shipped", customer_id: customer.id)

      initial_invoice_count = Invoice.count
      merchant.destroy
      final_invoice_count = Invoice.count
      expect(final_invoice_count).to eq(initial_invoice_count -1)
    end

    it 'destroys associated invoice_items when merchant is deleted' do
      merchant = Merchant.create!(name: "Test Merchant")
      item = merchant.items.create!(name: "Test Item", description: "Desc", unit_price: 50)
      customer = Customer.create!(first_name: "John", last_name: "Smith")
      invoice = merchant.invoices.create!(status: "shipped", customer_id: customer.id)
      item.invoice_items.create!(invoice_id: invoice.id, quantity: 5, unit_price: 50)

      initial_invoice_item_count = InvoiceItem.count
      merchant.destroy
      final_invoice_item_count = InvoiceItem.count
      expect(final_invoice_item_count).to eq(initial_invoice_item_count -1)
    end

    it 'destroys associated transactions when merchant is deleted' do
      merchant = Merchant.create!(name: "Test Merchant")
      customer = Customer.create!(first_name: "Sam", last_name: "Doe")
      invoice = merchant.invoices.create!(status: "shipped", customer_id: customer.id)
      invoice.transactions.create!(credit_card_number: "1234567890123456", result: "success")

      initial_transaction_count = Transaction.count
      merchant.destroy
      final_transaction_count = Transaction.count
      expect(final_transaction_count).to eq(initial_transaction_count -1)
    end
  end
  describe 'filter by name' do
    it 'can filter merchants by name query' do
      merchant1 = Merchant.create!(name: "Johnson Inc")
      merchant2 = Merchant.create!(name: "Zemlak-Collins")
      merchant3 = Merchant.create!(name: "Pollich, Romaguera and Bayer")

      result = Merchant.filter_name("Zem")
      expect(result).to eq(merchant2)
      
      no_result = Merchant.filter_name("xxx")
      expect(no_result).to eq(nil)
    end
  end
end