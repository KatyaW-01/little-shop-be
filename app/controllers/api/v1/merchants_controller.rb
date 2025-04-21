class Api::V1::MerchantsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  rescue_from ActionController::ParameterMissing, with: :incomplete_response
  rescue_from ActiveRecord::RecordInvalid, with: :incomplete_response
  #rescue_from ActionDispatch::Http::Parameters::ParseError, with: :malformed_json_response

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
  
  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantSerializer.new(merchant)
  end
  
  def create
    merchant = Merchant.create!(merchant_params)
    render json: MerchantSerializer.new(merchant), status: :created
  end

  def update
    merchant = Merchant.find(params[:id])
    merchant.update(merchant_params)
    render json: MerchantSerializer.new(merchant)
  end
  
  def destroy
      merchant = Merchant.find(params[:id])
      merchant.destroy
      head :no_content
  end 

  def find
    if params[:name]
      merchant = Merchant.filter_name(params[:name])
      if merchant
        render json: MerchantSerializer.new(merchant)
      else
        render json: {data: {} }, status: :ok
      end
      
    end
  end

  private

  def merchant_params
    params.require(:merchant).permit(:name)
  end

  def not_found_response(exception)
    render json: ErrorSerializer.serialize(exception), status: :not_found
  end

  def incomplete_response(exception)
    render json: ErrorSerializer.serialize(exception), status: :bad_request
  end

  # def malformed_json_response(exception)
  #   render json: ErrorSerializer.serialize(exception), status: :bad_request
  # end

end
