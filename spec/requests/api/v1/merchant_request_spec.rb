
require "rails_helper"

RSpec.describe "Merchant API", type: :request do
  #happy path
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

  xit "will gracefully handle if a merchant doesnt exist" do
      get "/api/v1/merchants/1238384893930"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)
      
      expect(data[:message]).to eq("your query could not be completed")
      expect(data[:errors]).to be_a(Array)
      expect(data[:errors]).to include("Couldn't find Merchant with 'id'=1238384893930")
  end

end