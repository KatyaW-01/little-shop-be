class Api::V1::ItemsController < ApplicationController
  def destroy
    item = Item.find(params[:id])
    item.destroy
    head :no_content
  end
end