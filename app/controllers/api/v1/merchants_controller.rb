class Api::V1::MerchantsController < ApplicationController
  
  def index
    merchant = Merchant.all
    render json: MerchantSerializer.new(merchant)
  end

  def create
    if params[:name].blank? # This can be made as a helper method after our error handling class
      render json: {
        message: "your query could not be completed",
        errors: ["Missing required parameter: name"]
      }, status: :bad_request
      return
    end

    merchant = Merchant.new(merchant_params)

    if merchant.save
      render json: MerchantSerializer.new(merchant), status: :created
    else
      render json: { # Same here, helper method would be more DRY
        message: "your query could not be completed",
        errors: merchant.errors.full_messages
      }, status: :bad_request
    end
  end

  private

    def merchant_params
      params.permit(:name)
    end
end

