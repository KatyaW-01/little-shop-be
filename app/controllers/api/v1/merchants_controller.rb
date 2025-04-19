class Api::V1::MerchantsController < ApplicationController
  
  def index
    if params[:sorted] == "age"
      merchants = Merchant.sorted_by_newest
      render json: MerchantSerializer.new(merchants)
    elsif params[:status] == "returned"
      merchants = Merchant.with_returned_items
      render json: MerchantSerializer.new(merchants)
    elsif params[:count] == "true"
      merchants = Merchant.with_item_counts
      render json: MerchantWithCountSerializer.new(merchants)
    else
      merchants = Merchant.all
      render json: MerchantSerializer.new(merchants)
    end
  end
  
  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantSerializer.new(merchant)
  end
  
  def create
    merchant = Merchant.create!(merchant_params)
    render json: MerchantSerializer.new(merchant), status: :created
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
