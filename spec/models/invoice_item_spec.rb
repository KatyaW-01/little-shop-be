require "rails_helper"
require "spec_helper"

RSpec.describe InvoiceItem, type: :model do
  it { should belong_to :invoice }
  it { should belong_to :item }

end