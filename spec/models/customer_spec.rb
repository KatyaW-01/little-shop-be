require "rails_helper"
require "spec_helper"

RSpec.describe Customer, type: :model do
  it { should have_many :invoices }

end