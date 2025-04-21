require "rails_helper"
require "spec_helper"

RSpec.describe Customer, type: :model do
  it { should have_many :invoices }

  describe "customers for the provided merchant" do
    it "provides the given merchants customers" do
      merchant = Merchant.create!(name: "Merchant With Customers")
      customer_1 = Customer.create!(first_name: "Jim", last_name: "Beam")
      customer_2 = Customer.create!(first_name: "Sarah", last_name: "Connor")
      invoice_1 = Invoice.create!(merchant_id: merchant.id, customer_id: customer_1.id, status: "shipped")
      invoice_2 = Invoice.create!(merchant_id: merchant.id, customer_id: customer_2.id, status: "shipped")

      result = Customer.for_merchant(merchant.id)

      expect(result.first).to eq(customer_1)
      expect(result.last).to eq(customer_2)
    end
  end

end