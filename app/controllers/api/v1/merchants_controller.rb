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
end

