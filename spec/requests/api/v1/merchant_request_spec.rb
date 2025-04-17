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
end