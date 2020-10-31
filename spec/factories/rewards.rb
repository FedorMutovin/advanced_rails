FactoryBot.define do
  factory :reward do
    name { 'Reward' }
    image { Rack::Test::UploadedFile.new(Rails.root.join('public/apple-touch-icon.png')) }
  end
end
