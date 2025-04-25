class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true
  validates :merchant_id, presence: true

  def self.sorted_by_price
    order(:unit_price)
  end

  def self.find_by_search(params)
    if params[:name]
      where("name ILIKE ?", "%#{params[:name]}%")
      .order(:name)
      .first
    elsif params[:min_price] && params[:max_price]
      where("unit_price >= ? AND unit_price <= ?", params[:min_price].to_f, params[:max_price].to_f)
      .order(:name)
      .first
    elsif params[:min_price]
      where("unit_price >= ?", params[:min_price].to_f)
      .order(:name)
      .first
    elsif params[:max_price]
      where("unit_price <= ?", params[:max_price].to_f)
      .order(:name)
      .first
    end
  end

  def self.find_all_by_search(params)
    if params[:name]
      where('name ILIKE ?', "%#{params[:name]}%").order(:name)
    elsif params[:min_price] && params[:max_price]
      where('unit_price >= ? AND unit_price <= ?', params[:min_price].to_f, params[:max_price].to_f).order(:name)
    elsif params[:min_price]
      where('unit_price >= ?', params[:min_price].to_f).order(:name)
    elsif params[:max_price]
      where('unit_price <= ?', params[:max_price].to_f).order(:name)
    end
  end
end