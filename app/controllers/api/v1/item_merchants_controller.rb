class Api::V1::ItemMerchantsController < ApplicationController
  def show
    item = Item.find(params[:id])
    merchant_id = item.merchant_id
    merchant = Merchant.find(merchant_id)
    render json: MerchantSerializer.new(merchant)
  end
end