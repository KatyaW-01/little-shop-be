class Api::V1::MerchantsCustomersController < ApplicationController
  def index
    merchant = Merchant.find_by(id: params[:merchant_id])
    return head :not_found unless merchant

    customers = Customer.for_merchant(merchant.id).limit(50)
    render json: CustomerSerializer.new(customers)
  end
end