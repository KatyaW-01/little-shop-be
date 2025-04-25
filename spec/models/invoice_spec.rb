require "rails_helper"
require "spec_helper"

RSpec.describe Invoice, type: :model do
  it { should belong_to(:coupon).optional}
  it { should belong_to :customer }
  it { should belong_to :merchant }
  it { should have_many :invoice_items }
  it { should have_many :transactions }

end