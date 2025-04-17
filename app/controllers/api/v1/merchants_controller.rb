class Api::V1::MerchantsController < ApplicationController
  
  def index
    merchant = Merchant.all
    render json: MerchantSerializer.new(merchant)
  end

  def destroy
    merchant = Merhcant.find(param[:id])
    merchant.destroy
    head :no_content
  end 
end

