FactoryBot.define do
  factory :question do
    sequence :title do |n|
      "qt#{n}"
    end
    sequence :body do |n|
      "qb#{n}"
    end

    trait :invalid do
      title { nil }
    end

    trait :with_files do
      before :create do |question|
        question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
        question.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb')
      end
    end
  end
end
