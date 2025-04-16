require "rails_helper"
require "spec_helper"

RSpec.describe Item, type: :model do
  it { should belong_to :merchant }
  it { should have_many :invoice_items }

end