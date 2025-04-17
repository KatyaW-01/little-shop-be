class Api::V1::MerchantsController < ApplicationController
  
  def index
    merchant = Merchant.all
    render json: MerchantSerializer.new(merchant)
  end

  def destroy
    # begin
      merchant = Merchant.find(params[:id])
      merchant.destroy
      head :no_content
    # rescue ActiveRecord::RecordNotFound => error
    #   render json: {
    #     "errors": [
    #       {
    #       status: "404",
    #       message: [error.message]
    #       }
    #     ]
    #   }, status: :not_found
    # end
  end 
end

