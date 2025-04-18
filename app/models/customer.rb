class Customer < ApplicationRecord
  has_many :invoices

  def self.for_merchant(merchant_id)
    includes(:invoices) # Guarding against N+1 if invoices get used later down the line
    .joins(:invoices)
    .where(invoices: { merchant_id: merchant_id })
    .distinct
  end
end

