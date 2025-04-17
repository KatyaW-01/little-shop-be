class Api::V1::MerchantsController < ApplicationController
  
  def index
    merchant = Merchant.all
    render json: MerchantSerializer.new(merchant)
  end

  def create
    return render_missing_param(:name) if params[:name].blank?

    merchant = Merchant.new(merchant_params)

    if merchant.save
      render json: MerchantSerializer.new(merchant), status: :created
    else
      render_error(
        "your query could not be completed",
        merchant.errors.full_messages
      )
    end
  end

  private

    def merchant_params
      params.permit(:name)
    end
end

