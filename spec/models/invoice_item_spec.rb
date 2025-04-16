require "rails_helper"
require "spec_helper"

RSpec.describe InvoiceItem, type: :model do
  it { should have_many :invoices}

end