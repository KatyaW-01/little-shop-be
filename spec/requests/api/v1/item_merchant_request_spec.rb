require 'rails_helper'

describe "Item Merchant API", type: :request do
  it 'can return the merchant for a particular item' do
    merchant = Merchant.create!(name: "Crafty Coders" )

    item = Item.create!(
      name: "Super Widget", 
      description: "A most excellent widget of the finest crafting",
      unit_price: 109.99,
      merchant_id: merchant.id)

    get "/api/v1/items/#{item.id}/merchant"

    expect(response).to be_successful

    merchant_response = JSON.parse(response.body, symbolize_names: true)

    data = merchant_response[:data]
    attributes = data[:attributes]

    expect(data[:id]).to eq(merchant.id.to_s)
    expect(data[:type]).to eq("merchant")
    expect(attributes[:name]).to eq("Crafty Coders")
  end
end