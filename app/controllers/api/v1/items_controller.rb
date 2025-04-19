class Api::V1::ItemsController < ApplicationController
  def index
    if params[:sorted] == "price"
      items = Item.sorted_by_price
      else
        items = Item.all
    end
    render json: ItemSerializer.new(items)
  end
end
