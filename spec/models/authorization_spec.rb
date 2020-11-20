require 'rails_helper'

RSpec.describe Authorization, type: :model do
  it { belong_to :user }
  it { is_expected.to validate_presence_of :provider }
  it { is_expected.to validate_presence_of :uid }
end
