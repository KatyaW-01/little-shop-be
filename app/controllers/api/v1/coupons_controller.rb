class Api::V1::CouponsController < ApplicationController
  rescue_from  ActiveRecord::RecordInvalid, with: :invalid_response
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def index
    if params[:status] == "active"
      merchant = Merchant.find(params[:merchant_id])
      coupons = merchant.return_active_coupons
      render json: CouponSerializer.new(coupons)
    elsif params[:status] == "inactive"
      merchant = Merchant.find(params[:merchant_id])
      coupons = merchant.return_inactive_coupons
      render json: CouponSerializer.new(coupons)
    else
      merchant = Merchant.find(params[:merchant_id])
      coupons = merchant.coupons
      render json: CouponSerializer.new(coupons)
    end
  end

  def show
    coupon = Coupon.find(params[:id])
    render json: CouponWithCountSerializer.new(coupon)
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    coupon = merchant.coupons.create!(coupon_params)
    render json: CouponSerializer.new(coupon)
  end

  def update
    coupon = Coupon.find(params[:id])
    coupon.update!(activate_or_deactivate_params)
    render json: CouponSerializer.new(coupon)
  end

  private

  def coupon_params
    params.require(:coupon).permit(:name, :code, :value, :value_type, :activated)
  end

  def activate_or_deactivate_params
    params.require(:coupon).permit(:activated)
  end

  def invalid_response(exception)
    render json: ErrorSerializer.serialize(exception), status: :bad_request
  end

  def not_found_response(exception)
    render json: ErrorSerializer.serialize(exception), status: :not_found
  end

end