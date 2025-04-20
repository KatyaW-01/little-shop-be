class Api::V1::ItemMerchantsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  def show
    item = Item.find(params[:id])
    merchant_id = item.merchant_id
    merchant = Merchant.find(merchant_id)
    render json: MerchantSerializer.new(merchant)
  end
  
  private
  def not_found_response(exception)
    render json: ErrorSerializer.serialize(exception), status: :not_found
  end
end