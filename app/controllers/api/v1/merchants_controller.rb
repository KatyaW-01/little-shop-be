class Api::V1::MerchantsController < ApplicationController
  
  def index
    merchant = Merchant.all
    render json: MerchantSerializer.new(merchant)
  end

  def destroy
    merchant = Merhcant.find_by(id: params[:id])
    
    if merchant
      merchant.destroy
      head :no_content
    else 
      render json: {
        message: "Unable to delete merchant",
        errors: ["Merchant ID #{params[:id]} is invalid"],
      }, status: :not_found
  end 
end

