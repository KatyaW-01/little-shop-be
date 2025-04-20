class Api::V1::MerchantsCustomersController < ApplicationController
  def index
    merchant = Merchant.find_by(id: params[:merchant_id])
    customers = Customer.for_merchant(merchant.id).limit(50)
    binding.pry
    render json: CustomerSerializer.new(customers)
  end
end