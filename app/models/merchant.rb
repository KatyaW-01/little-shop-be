class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices

  def self.sorted_by_newest
    order(created_at: :desc)
  end

  def self.with_returned_items
    joins(invoices: :transactions)
    .where(transactions: {result: "refunded" })
    .distinct
  end
end