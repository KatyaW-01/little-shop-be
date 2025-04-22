
require "rails_helper"

RSpec.describe "Item API", type: :request do
  
  describe "GET /api/v1/items" do
    it "can fetch all items" do
      merchant1 = Merchant.create!(name: "Merchant One")
    
      Item.create!(name: "Item 1", description: "Description for item 1", unit_price: 15.99, merchant_id: merchant1.id)
      Item.create!(name: "Item 2", description: "Description for item 2", unit_price: 25.50, merchant_id: merchant1.id)
      Item.create!(name: "Item 3", description: "Description for item 3", unit_price: 10.00, merchant_id: merchant1.id)
  
      get "/api/v1/items"
  
      expect(response).to be_successful
  
      json = JSON.parse(response.body, symbolize_names: true)
  
      expect(json[:data].count).to eq(3)
      expect(json[:data].first[:type]).to eq("item")
      expect(json[:data].first[:attributes]).to have_key(:name)
    end
  end
  describe "GET /api/v1/items?sorted=price" do
    it "can sort all items by price" do
      merchant = Merchant.create!(name: "Alfanzo")

      item1 = Item.create!(name: "Item Nemo Facere", description: "Description for item 1", unit_price: 42.91, merchant: merchant)
      item2 = Item.create!(name: "Item Provident At", description: "Description for item 2", unit_price: 159.25, merchant: merchant)
      item3 = Item.create!(name: "Item Expedita Aliquam", description: "Description for item 3", unit_price: 687.23, merchant: merchant)
      

      get "/api/v1/items?sorted=price"

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)

      items = json[:data]
    
      expect(items[0][:attributes][:unit_price]).to eq(item1.unit_price.to_f)
    end
  end
  describe "GET /api/v1/items/item_id " do
    it 'can get one item by its id' do
      merchant = Merchant.create!(name: "Crafty Coders" )

      item = Item.create!(
        name: "Super Widget", 
        description: "A most excellent widget of the finest crafting",
        unit_price: 109.99,
        merchant_id: merchant.id)

      get "/api/v1/items/#{item.id}"

      expect(response).to be_successful

      item_response = JSON.parse(response.body, symbolize_names: true)

      data = item_response[:data]
      attributes = data[:attributes]

      expect(data[:id]).to eq(item.id.to_s)
      expect(data[:type]).to eq("item")
      expect(attributes[:name]).to eq("Super Widget")
      expect(attributes[:description]).to eq("A most excellent widget of the finest crafting")
      expect(attributes[:unit_price]).to eq(109.99)
    end

    it "will gracefully handle if a item does not exist" do
      get "/api/v1/items/173850383737"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:message]).to eq("your query could not be completed")
      expect(data[:errors]).to be_a(Array)
      expect(data[:errors]).to include("Couldn't find Item with 'id'=173850383737")
    end
  end
  describe 'destroy' do
    it 'deletes a item and returns not content' do
      merchant = Merchant.create!(name: "Test Merchant")
      item = merchant.items.create!(name: "Test Item", description: "Born to be deleted", unit_price: 10)

      delete "/api/v1/items/#{item.id}"

      expect(response).to have_http_status(:no_content)
      expect(Item.find_by(id: item.id)).to be_nil
    end

    it 'returns a not_found error' do
      delete "/api/v1/items/99999"

      expect(response).to_not be_successful

      parsed_json = JSON.parse(response.body, symbolize_names: true)

      expect(parsed_json[:message]).to eq("your query could not be completed")
      expect(parsed_json[:errors]).to be_an(Array)
      expect(parsed_json[:errors]).to include("Couldn't find Item with 'id'=99999")
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
  describe "POST /api/v1/items" do
    it "creates an item with valid params" do
      merchant = Merchant.create!(name: "Target")
      item_params = {
        name: "Toy Car",
        description: "Red hot wheels toy",
        unit_price: 9.99,
        merchant_id: merchant.id
      }

      post "/api/v1/items", params: { item: item_params }

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data][:type]).to eq("item")
      expect(json[:data][:attributes][:name]).to eq("Toy Car")
      expect(json[:data][:attributes][:description]).to eq("Red hot wheels toy")
      expect(json[:data][:attributes][:unit_price]).to eq(9.99)
      expect(json[:data][:attributes][:merchant_id]).to eq(merchant.id)
    end

    it "returns 400 if any param is missing" do 
      post "/api/v1/items", params: { item: { name: "Incomplete" } }

      expect(response.status).to eq(400)

      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:message]).to eq("your query could not be completed")
      expect(json[:errors]).to be_a(Array)
    end

    it "returns 400 if any param is missing" do 
      headers = { "CONTENT_TYPE" => "application/json" }
      bad_json = '{ "item": { "name": } }'
      post "/api/v1/items", headers: headers,params: bad_json 

      expect(response.status).to eq(400)

      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:message]).to eq("your query could not be completed")
      expect(json[:errors]).to be_a(Array)
    end
  end
  
  describe "PATCH /api/v1/items/:id" do
    it "updates an item with valid params" do
      merchant = Merchant.create!(name: "Target")
      item = Item.create!(
        name: "Old Toy",
        description: "Old description",
        unit_price: 4.99,
        merchant_id: merchant.id
      )
  
      patch "/api/v1/items/#{item.id}", params: {
        item: {
          name: "New Toy",
          description: "New description",
          unit_price: 6.49
        }
      }
  
      expect(response).to be_successful
  
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data][:attributes][:name]).to eq("New Toy")
      expect(json[:data][:attributes][:unit_price]).to eq(6.49)
      expect(json[:data][:attributes][:description]).to eq("New description")
    end

    it "returns 404 if item does not exist" do
      patch "/api/v1/items/999999", params: {
        item: { name: "Doesn't Matter" }
      }

      expect(response.status).to eq(404)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:message]).to eq("your query could not be completed")
      expect(json[:errors]).to include("Couldn't find Item with 'id'=999999")
    end
  end
  
end