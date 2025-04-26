class Api::V1::InvoicesController < ApplicationController
  rescue_from  ActiveRecord::RecordNotFound, with: :incomplete_response
  rescue_from InvalidStatusError, with: :invalid_status_error

  VALID_STATUSES = ["shipped", "returned", "packaged"]

  def index
    status = params[:status] 

    if status.present? && !VALID_STATUSES.include?(status)
      raise InvalidStatusError, "Invalid status."
    end

    merchant = Merchant.find(params[:merchant_id]) 
    if status.present?
      invoices = merchant.filter_by_status(status)
      render json: InvoiceSerializer.new(invoices)
    else
      invoices = merchant.invoices 
      render json: InvoiceSerializer.new(invoices)
    end

  end
  private
  def incomplete_response(exception)
    render json: ErrorSerializer.serialize(exception), status: :not_found
  end

  def invalid_status_error(exception)
    render json: ErrorSerializer.serialize(exception), status: :bad_request
  end
end