class Api::V1::ItemsSearchController < ApplicationController
  rescue_from ActionController::ParameterMissing, with: :incomplete_response
  rescue_from ArgumentError, with: :incomplete_response
  rescue_from ActionDispatch::Http::Parameters::ParseError, with: :malformed_json_response

  def find
    validate_single_param_set!
    validate_price_range!
    item = Item.find_by_search(params)
    render json: ItemSerializer.new(item)
  end

  def find_all
    validate_single_param_set!
    validate_price_range!
    items = Item.find_all_by_search(params)
    render json: ItemSerializer.new(items)
  end

  private

    def validate_single_param_set!
      if params[:name].present? && (params[:min_price].present? || params[:max_price].present?)
        raise ArgumentError, "Cannot search by name and price simultaneously"
      end

      if params[:name].blank? && params[:min_price].blank? && params[:max_price].blank?
        raise ActionController::ParameterMissing, "name or price range"
      end
    end

    def validate_price_range!
      if params[:min_price].present? && params[:min_price].to_f < 0
        raise ArgumentError, "min_price must be a non-negative value"
      end

      if params[:max_price].present? && params[:max_price].to_f < 0
        raise ArgumentError, "max_price must be a non-negative value"
      end
    end

    def incomplete_response(exception)
      render json: ErrorSerializer.serialize(exception), status: :bad_request
    end

    def malformed_json_response(exception)
      render json: ErrorSerializer.serialize(exception), status: :bad_request
    end
end