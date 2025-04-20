require "rails_helper"

RSpec.describe "Merchant API", type: :request do
  describe "GET /api/v1/merchants" do
    it "can fetch all merchants" do
      Merchant.create(name: "Merchant 1")
      Merchant.create(name: "Merchant 2")
      Merchant.create(name: "Merchant 3")

      get "/api/v1/merchants"

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data].count).to eq(3)
      expect(json[:data].first[:type]).to eq("merchant")
      expect(json[:data].first[:attributes]).to have_key(:name)
    end
  end
    
  describe "GET /api/v1/merchants?sorted=age" do
    it "returns merchants sorted by created_at desc (newest first)" do
      old_merchant = Merchant.create!(name: "Older Store", created_at: 5.days.ago)
      newest_merchant = Merchant.create!(name: "Newer Store", created_at: 1.day.ago)
  
      get "/api/v1/merchants?sorted=age"
  
      expect(response).to be_successful
  
      json = JSON.parse(response.body, symbolize_names: true)

      first = json[:data].first[:attributes][:name]
  
      expect(first).to eq("Newer Store")
    end
  end

  describe "GET /api/v1/merchants?status=returned" do 
    it "get all merchants with returned items" do
      
      merchant_with_refund_1 = Merchant.create!(name: 'Refund Merchant One')
      customer1 = Customer.create!(first_name: "mike", last_name: "jones")
      invoice_one = Invoice.create!(merchant_id: merchant_with_refund_1.id, status: "returned", customer_id: customer1.id )
      Transaction.create!(invoice_id: invoice_one.id, result: 'refunded')


      merchant_with_refund_2 = Merchant.create!(name: 'Refund Merchant Two')
      customer2 = Customer.create!(first_name: "mark", last_name: "bones")
      invoice_two = Invoice.create!(merchant_id: merchant_with_refund_2.id, status: "returned", customer_id: customer2.id )
      Transaction.create!(invoice_id: invoice_two.id, result: 'refunded')
      Transaction.create!(invoice_id: invoice_two.id, result: 'success')

      merchant_without_refund = Merchant.create!(name: 'No Refund Merchant')
      customer3 = Customer.create!(first_name: "mac", last_name: "hones")
      invoice_three = Invoice.create!(merchant_id: merchant_without_refund.id, customer_id: customer3.id )
      Transaction.create!(invoice_id: invoice_three.id, result: 'success')
    

      get "/api/v1/merchants?status=returned"

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)
      
      merchants_data = json[:data]
    
      expect(merchants_data.count).to eq(2)
      expect(merchants_data.any? { |merchant| merchant[:attributes][:name] == 'Refund Merchant One' }).to be_truthy
      expect(merchants_data.any? { |merchant| merchant[:attributes][:name] == 'Refund Merchant Two' }).to be_truthy
      expect(merchants_data.none? { |merchant| merchant[:attributes][:name] == 'No Refund Merchant' }).to be_truthy

    end
  end
    
  describe "GET /api/v1/merchants?count=true" do 
    it "get all merchants with item count" do
      merchant1 = Merchant.create!(name: "Merchant One")
  
      Item.create!(name: "Item 1", description: "banana", unit_price: 58.78, merchant_id: merchant1.id)
      Item.create!(name: "Item 2", description: "cat", unit_price: 999.78, merchant_id: merchant1.id)
      Item.create!(name: "Item 3", description: "moose", unit_price: 85.78, merchant_id: merchant1.id)

      get "/api/v1/merchants?count=true"

        expect(response).to be_successful

        json = JSON.parse(response.body, symbolize_names: true)

        merchants_item_count = json[:data]

      expect(merchants_item_count[0][:attributes][:item_count]).to eq(3)
    end
  end
  describe "GET /api/v1/merchants/merchant.id" do
    it 'can get one merchant by its id' do
      merchant = Merchant.create!(name: "Schroeder-Jerde")

      get "/api/v1/merchants/#{merchant.id}"

      expect(response).to be_successful

      merchant_response = JSON.parse(response.body, symbolize_names: true)

      data = merchant_response[:data]
      attributes = data[:attributes]

      expect(data[:id]).to eq(merchant.id.to_s)
      expect(data[:type]).to eq("merchant")
      expect(attributes[:name]).to eq("Schroeder-Jerde")
    end

    it "will gracefully handle if a merchant doesnt exist" do 
        get "/api/v1/merchants/1238384893930"

        expect(response).to_not be_successful
        expect(response.status).to eq(404)

        data = JSON.parse(response.body, symbolize_names: true)
        
        expect(data[:message]).to eq("your query could not be completed")
        expect(data[:errors]).to be_a(Array)
        expect(data[:errors]).to include("Couldn't find Merchant with 'id'=1238384893930")
    end
  end
  describe "POST /api/v1/merchants" do
    it "creates a merchant with valid params" do
      merchant_params = { name: "Toys R Us" }

      post "/api/v1/merchants", params: { merchant: merchant_params }

      expect(response).to have_http_status(:created)

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data][:type]).to eq("merchant")
      expect(json[:data][:attributes][:name]).to eq("Toys R Us")
    end

    it "returns 400 if name param is missing" do
      post "/api/v1/merchants", params: {}

      expect(response).to_not be_successful
      #expect(response.status).to eq(404)

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:errors]).to be_a(Array)
      expect(json[:message]).to eq("your query could not be completed")
      expect(json[:errors]).to include("param is missing or the value is empty: merchant")
    end

    it "returns 400 if name param is blank" do
      post "/api/v1/merchants", params: { name: "" }

      expect(response).to_not be_successful
      #expect(response.status).to eq(404)

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:errors]).to be_a(Array)
      expect(json[:message]).to eq("your query could not be completed")
      expect(json[:errors]).to include("param is missing or the value is empty: merchant")
    end
    
  end

  describe "PATCH /api/v1/merchants/:id" do
    it "updates a merchant with valid params" do
      merchant = Merchant.create!(name: "Old Name")
  
      patch "/api/v1/merchants/#{merchant.id}", params: { merchant: { name: "New Name" } }
  
      expect(response).to have_http_status(:ok)
  
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data][:attributes][:name]).to eq("New Name")
    end

    it "returns 404 if merchant does not exist" do
      patch "/api/v1/merchants/999999", params: { merchant: { name: "Whatever" } }

      expect(response.status).to eq(404)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:message]).to eq("your query could not be completed")
      expect(json[:errors]).to include("Couldn't find Merchant with 'id'=999999")
    end
  end
  describe 'destroy' do
    it 'deletes a merchant and returns not content' do
      merchant = Merchant.create!(name: "Test Merchant")

      delete "/api/v1/merchants/#{merchant.id}"

      expect(response).to have_http_status(:no_content)
      expect(Merchant.find_by(id: merchant.id)).to be_nil
    end

    it 'returns a not_found error' do
      delete "/api/v1/merchants/99999"

      expect(response).to have_http_status(:not_found)

      parsed_json = JSON.parse(response.body, symbolize_names: true)
     
      expect(parsed_json[:message]).to eq("your query could not be completed")
      expect(parsed_json[:errors]).to be_an(Array)
      expect(parsed_json[:errors]).to include("Couldn't find Merchant with 'id'=99999")
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