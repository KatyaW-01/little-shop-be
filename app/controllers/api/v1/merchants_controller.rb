class Api::V1::MerchantsController < ApplicationController
  
  def index
    merchant = Merchant.all
    render json: MerchantSerializer.new(merchant)
  end
  
  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantSerializer.new(merchant)
  end
  
  def create
    merchant = Merchant.create!(merchant_params)
    render json: MerchantSerializer.new(merchant)
  end

  def update
    merchant = Merchant.find(params[:id])

    merchant.update(merchant_params)

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

  private

    def merchant_params
      params.require(:merchant).permit(:name)
    end
end
