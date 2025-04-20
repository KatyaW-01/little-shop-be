class Api::V1::InvoicesController < ApplicationController
  rescue_from  ActiveRecord::RecordNotFound, with: :incomplete_response
  def index
    status = params[:status] #grabs the value of the status query parameter - shipped, packaged, returned
    merchant = Merchant.find(params[:merchant_id]) #looks up merchant with given merchant id frome the URL
    invoices = merchant.invoices.where(status: status) #this will get all the merchants invoices that match the status being passed in

    render json: InvoiceSerializer.new(invoices)

  end
  private

  def incomplete_response(exception)
    render json: ErrorSerializer.serialize(exception), status: :not_found
  end
end