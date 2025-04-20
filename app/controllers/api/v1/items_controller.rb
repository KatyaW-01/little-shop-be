class Api::V1::ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :incomplete_response
  rescue_from ActionController::ParameterMissing, with: :missing_param_response
  rescue_from ActionDispatch::Http::Parameters::ParseError, with: :malformed_json_response

  def index
    if params[:sorted] == "price"
      items = Item.sorted_by_price
      render json: ItemSerializer.new(items)
    else
      items = Item.all
      render json: ItemSerializer.new(items)
    end
    
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

  def not_found_response(exception)
    render json: ErrorSerializer.serialize(exception), status: :not_found
  end
  
  def incomplete_response(exception)
    render json: ErrorSerializer.serialize(exception), status: :bad_request
  end

  def missing_param_response(exception)
    render json: ErrorSerializer.serialize(exception), status: :bad_request
  end

  def malformed_json_response(exception)
    render json: ErrorSerializer.serialize("Malformed or missing JSON body"), status: :bad_request
  end
end
