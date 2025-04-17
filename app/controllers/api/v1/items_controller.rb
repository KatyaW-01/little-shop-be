class Api::V1::ItemsController < ApplicationController
  def index

  end

  def create
    if params[:name].blank?
      head :bad_request
      return
    end
    
    item = Item.new(item_params)

    if item.save
      render json: ItemSerializer.new(item), status: :created
    else
      head :bad_request
    end
  end

  private
    
    def item_params
      params.permit(:name, :description, :unit_price, :merchant_id)
    end
end