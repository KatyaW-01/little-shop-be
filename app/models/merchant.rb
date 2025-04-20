class Merchant < ApplicationRecord

  has_many :items, dependent: :destroy
  has_many :invoices, dependent: :destroy
  validates :name, presence: true

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

end