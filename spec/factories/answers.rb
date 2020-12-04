FactoryBot.define do
  factory :answer do
    sequence :body do |n|
      "answer#{n}"
    end

    trait :invalid do
      body { nil }
    end

    trait :with_files do
      before :create do |answer|
        answer.files.attach(io: File.open(Rails.root.join('spec/rails_helper.rb')), filename: 'rails_helper.rb')
        answer.files.attach(io: File.open(Rails.root.join('spec/spec_helper.rb')), filename: 'spec_helper.rb')
      end
    end

    trait :with_link do
      before :create do |answer|
        create(:google_link, linkable: answer)
      end
    end
  end
end
