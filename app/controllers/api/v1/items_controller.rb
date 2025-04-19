class Api::V1::ItemsController < ApplicationController
  
  def index

  end
  
  def show
    item = Item.find(params[:id])
    render json: ItemSerializer.new(item)
  end

  def create
    item = Item.create!(item_params)
    render json: ItemSerializer.new(item), status: :created
  end

  def update
    item = Item.find(params[:id])
    item.update(item_params)
    render json: ItemSerializer.new(item), status: :ok
  end
  
  def destroy
    item = Item.find(params[:id])
    item.destroy
    head :no_content
  end
  
  private
    
    def item_params
      params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end
end
