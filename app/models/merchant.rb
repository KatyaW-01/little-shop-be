class Merchant < ApplicationRecord
  has_many :coupons
  has_many :items, dependent: :destroy
  has_many :invoices, dependent: :destroy
  validates :name, presence: true

  def return_active_coupons
    coupons.where("activated = true")
  end

  def return_inactive_coupons
    coupons.where("activated = false")
  end

  def self.sorted_by_newest
    order(created_at: :desc)
  end

  def self.with_returned_items
    joins(invoices: :transactions)
    .where(transactions: {result: "refunded" })
    .distinct
  end

  def self.with_item_counts
    left_joins(:items)
      .select("merchants.*, COUNT(items.id) AS item_count")
      .group("merchants.id")
      .order(:id)
  end

  def item_count
    self[:item_count] || items.size
  end

  def self.filter_name(name)
    where("LOWER(name) LIKE?", "%#{name.downcase}%").order("LOWER(name) ASC").first
  end

  def filter_by_status(status)
    invoices.where(status: status)
  end

end