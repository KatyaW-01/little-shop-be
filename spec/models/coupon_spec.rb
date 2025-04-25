require "rails_helper"
require "spec_helper"

RSpec.describe Coupon, type: :model do
  it {should belong_to :merchant}
  it {is_expected.to validate_presence_of :code}
end