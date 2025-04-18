require 'rails_helper'

describe "Items API", type: :request do
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