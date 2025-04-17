class Api::V1::MerchantsController < ApplicationController
  
  def index
    merchant = Merchant.all
    render json: MerchantSerializer.new(merchant)
  end

  def create
    merchant = Merchant.create!(merchant_params)

    render json: MerchantSerializer.new(merchant), status: :created
  end

  def update
    merchant = Merchant.find(params[:id])

    merchant.update(merchant_params)

    render json: MerchantSerializer.new(merchant), status: :ok
  end

  private

    def merchant_params
      params.require(:merchant).permit(:name)
    end
end

