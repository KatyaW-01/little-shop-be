class Api::V1::MerchantsController < ApplicationController
  
  def index
    merchant = Merchant.all
    render json: MerchantSerializer.new(merchant)
  end

  def destroy
  end 
end

