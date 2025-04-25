class Api::V1::CouponsController < ApplicationController

  def index
    coupons = Coupon.all
    render json: CouponSerializer.new(coupons)
  end

  def show
    coupon = Coupon.find(params[:id])
    render json: CouponSerializer.new(coupon)
    #add a count of how many times it has been used
  end

  def create
    coupon = Coupon.create!(coupon_params)
    render json: CouponSerializer.new(coupon)
  end

  def update

  end

  private

  def item_params
    params.require(:coupon).permit(:name, :code, :value, :value_type, :activated, :merchant_id)
  end
  
end