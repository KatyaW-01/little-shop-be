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
  describe 'sort by newest' do
    it 'can sort by the created_at date in descending order' do
      merchant1 = Merchant.create!(name: "Johnson Inc",created_at: "2024-04-21 14:53:30" )
      merchant2 = Merchant.create!(name: "Zemlak-Collins",created_at: "2024-04-21 14:53:42")
      merchant3 = Merchant.create!(name: "Pollich, Romaguera and Bayer",created_at: "2024-04-21 14:53:59")

      results = Merchant.where(id: [merchant1.id, merchant2.id, merchant3.id]).sorted_by_newest
      expect(results.first).to eq(merchant3)
      expect(results.last).to eq(merchant1)
    end
  end
  describe 'returned items' do
    it 'can join invoices and transactions' do
      merchant_with_refund_1 = Merchant.create!(name: 'Refund Merchant One')
      customer1 = Customer.create!(first_name: "mike", last_name: "jones")
      invoice_one = Invoice.create!(merchant_id: merchant_with_refund_1.id, status: "returned", customer_id: customer1.id )
      Transaction.create!(invoice_id: invoice_one.id, result: 'refunded')

      results = Merchant.with_returned_items
      expect(results).to include(merchant_with_refund_1)
    end
  end
  describe 'with item counts' do
    it 'adds item count attribute to merchants' do
      merchant1 = Merchant.create!(name: "Merchant One")
  
      Item.create!(name: "Item 1", description: "banana", unit_price: 58.78, merchant_id: merchant1.id)
      Item.create!(name: "Item 2", description: "cat", unit_price: 999.78, merchant_id: merchant1.id)
      Item.create!(name: "Item 3", description: "moose", unit_price: 85.78, merchant_id: merchant1.id)
      
      results = Merchant.where(id: [merchant1.id]).with_item_counts
   
      expect(results[0][:item_count]).to eq(3)
    end
  end
  describe 'item count' do
    it 'it can count a merchants items' do
      merchant1 = Merchant.create!(name: "Merchant One")
  
      Item.create!(name: "Item 1", description: "banana", unit_price: 58.78, merchant_id: merchant1.id)
      Item.create!(name: "Item 2", description: "cat", unit_price: 999.78, merchant_id: merchant1.id)
      Item.create!(name: "Item 3", description: "moose", unit_price: 85.78, merchant_id: merchant1.id)

      results = merchant1.item_count
      expect(results).to eq(3)
      expect(merchant1.items.size).to eq(3)
      expect(results).to eq(merchant1.items.size)

    end
  end
end