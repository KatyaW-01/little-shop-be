require "rails_helper"
require "spec_helper"

RSpec.describe Transaction, type: :model do
  it { should belong_to :invoice }

end