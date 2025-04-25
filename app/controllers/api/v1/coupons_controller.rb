class Api::V1::CouponsController < ApplicationController

  def index
    merchant = Merchant.find(params[:merchant_id])
    coupons = merchant.coupons
    render json: CouponSerializer.new(coupons)
  end

  def show
    coupon = Coupon.find(params[:id])
    render json: CouponSerializer.new(coupon)
    #add a count of how many times it has been used
    # count will be how many invoices the coupon is attached to
  end

  def create
    coupon = Coupon.create!(coupon_params)
    render json: CouponSerializer.new(coupon)
  end

  def update
    coupon = Coupon.find(params[:id])
    coupon.update!(activate_or_deactivate_params)
    #add sad path cannot deactivate if any pending invoices with coupon
  end

  private

  def coupon_params
    params.require(:coupon).permit(:name, :code, :value, :value_type, :activated, :merchant_id)
  end

  def acactivate_or_deactivate_params
    params.require(:coupon).permit(:activated)
  end

end