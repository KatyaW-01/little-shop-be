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

  describe ".find_by_search" do
    before :each do
      @merchant = Merchant.create!(name: "Searchy Searcher")
      @item1 = Item.create!(name: "Gold Ring", description: "Shiny", unit_price: 200, merchant: @merchant)
      @item2 = Item.create!(name: "Silver Ring", description: "Less shiny", unit_price: 150, merchant: @merchant)
      @item3 = Item.create!(name: "Wooden Spoon", description: "Not shiny", unit_price: 10, merchant: @merchant)
    end

    it "finds a single item by name fragment" do
      result = Item.find_by_search({ name: "ring" })
      expect(result).to eq(@item1)
    end

    it "find a single item by min and max price" do
      result = Item.find_by_search({ min_price: "100", max_price: "200" })
      expect(result).to eq(@item2) # Alphabetical sorting also
    end

    it "finds a single item by min price only" do
      result = Item.find_by_search({ min_price: "160" })
      expect(result).to eq(@item1)
    end

    it "finds a single item by max price only" do
      result = Item.find_by_search({ max_price: "20" })
      expect(result).to eq(@item3)
    end
  end

  describe ".find_all_by_search" do
    before :each do
      @merchant = Merchant.create!(name: "Searchy Searcher")
      @item1 = Item.create!(name: "Gold Ring", description: "Shiny", unit_price: 200, merchant: @merchant)
      @item2 = Item.create!(name: "Silver Ring", description: "Less shiny", unit_price: 150, merchant: @merchant)
      @item3 = Item.create!(name: "Wooden Spoon", description: "Not shiny", unit_price: 10, merchant: @merchant)
    end

    
  end
end