require 'rails_helper'

describe "Merchant Item API", type: :request do
  it 'can return all the items for a particular merchant' do
    merchant = Merchant.create!(name: "Store of Fate" )

    Item.create!(
      name: "Portable Campfire",
      description: "A lightweight, foldable campfire for cozy evenings under the stars.",
      unit_price:  89.50,
      merchant_id: merchant.id)

    Item.create!(
      name: "Enchanted Grappling Hook",
      description: "Crafted by dwarves, blessed by elves — perfect for scaling cliffs or stealing hearts.",
      unit_price: 249.99,
      merchant_id: merchant.id)

    Item.create!(
      name: "Mystic Compass",
      description: "Always points to what your heart desires… or at least north. Results may vary.",
      unit_price: 134.75,
      merchant_id: merchant.id)

    get "/api/v1/merchants/#{merchant.id}/items"

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items).to have_key(:data)
    expect(items[:data]).to be_an(Array)

    items[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_an(String)
      expect(item).to have_key(:type)
      expect(item[:type]).to be_a(String)
      expect(item).to have_key(:attributes)

      attributes = item[:attributes]

      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)

      expect(attributes).to have_key(:description)
      expect(attributes[:description]).to be_a(String)

      expect(attributes).to have_key(:unit_price)
      expect(attributes[:unit_price]).to be_an(Float)

      expect(attributes).to have_key(:merchant_id)
      expect(attributes[:merchant_id]).to be_an(Integer)
    end
  end
end