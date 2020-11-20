require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :voteable }

  it { is_expected.to validate_presence_of :value }
end
