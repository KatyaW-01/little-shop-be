require 'rails_helper'

describe "Merchants API", type: :request do
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