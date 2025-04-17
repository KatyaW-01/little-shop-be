class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices

  validates :name, presence: true # To pass the sad path test
  
end