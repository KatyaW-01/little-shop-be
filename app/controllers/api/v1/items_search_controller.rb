class Api::V1::ItemsSearchController < ApplicationController
  resuce_from ActionController::ParameterMissing, with: :missing_param_response
  resuce_from ArgumentError, with: :incomplete_response

  def find
    validate_single_param_set!
    item = Item.find_by_search(params)
    render json: ItemSerializer.new(item)
  end

  def find_all
    validate_single_param_set!
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

    def missing_param_response(error)
      render json: ErrorSerializer.serialize(error), status: :bad_request
    end

    def incomplete_response(error)
      render json: ErrorSerializer.serialize(error), status: :bad_request
    end
end