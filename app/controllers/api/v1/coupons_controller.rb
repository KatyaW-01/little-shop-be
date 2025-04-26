class Api::V1::CouponsController < ApplicationController

  def index
    merchant = Merchant.find(params[:merchant_id])
    coupons = merchant.coupons
    render json: CouponSerializer.new(coupons)
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

end