require "rails_helper"

RSpec.describe "Merchant endpoints", type: :request do
  describe 'destroy a merchant' do
    it 'deletes a merchant and returns not content' do
      merchant = Merchant.create!(name: "Test Merchant")

      delete "/api/v1/merchants/#{merchant.id}"

      expect(response).to have_http_status(:no_content)
      expect(Merchant.find_by(id: merchant.id)).to be_nil
    end

    # it 'returns a not_found error' do
    #   delete "/api/v1/merchants/99999"

    #   expect(response).to have_http_status(:not_found)

    #   parsed_json = JSON.parse(response.body, symbolize_names: true)
    #   errors = parsed_json[:errors].first

    #   expect(errors[:status]).to eq("404")
    #   expect(errors[:message]).to include("Couldn't find Merchant with 'id'=99999")
    # end

    it 'also deletes associated items when merchant is deleted' do 
      merchant = Merchant.create!(name: "Test Cascading")
     
      item1 = merchant.items.create!(name: "Item 1", description: "Born to be deleted", unit_price: 10)
      item2 = merchant.items.create!(name: "Item 2", description: "Second born to be deleted", unit_price: 20)

      intial_item_count = Item.count 
      delete "/api/v1/merchants/#{merchant.id}"
      final_item_count = Item.count 
    
      expect(final_item_count).to eq(intial_item_count - 2)
    end
  end
end