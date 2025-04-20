class Api::V1::InvoicesController < ApplicationController
  VALID_STATUSES = ["shipped", "returned", "packaged"]

  rescue_from InvalidStatusError, with: :invalid_status_error

  def index
    status = params[:status] #grabs the value of the status query parameter - shipped, packaged, returned
    merchant = Merchant.find(params[:merchant_id]) #looks up merchant with given merchant id frome the URL
    invoices = merchant.invoices.where(status: status) #this will get all the merchants invoices that match the status being passed in

    render json: InvoiceSerializer.new(invoices)
  end

  private
  def invalid_status_error(exception)
    render json: ErrorSerializer.serialize(exception), status: :bad_request
  end
end