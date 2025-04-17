class Api::V1::ItemsController < ApplicationController
  def index

  end

  def create
    return render_missing_param(:name) if params[:name].blank?

    item = Item.new(item_params)

    if item.save
      render json: ItemSerializer.new(item), status: :created
    else
      render_error(
        "your query could not be completed",
        item.errors.full_messages
      )
    end
  end

  private
    
    def item_params
      params.permit(:name, :description, :unit_price, :merchant_id)
    end
end