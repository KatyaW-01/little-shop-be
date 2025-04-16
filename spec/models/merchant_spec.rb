require "rails_helper"
require "spec_helper"

RSpec.describe Merchant, type: :model do
  it { should have_many :items }
  it { should have_many :invoices }

end