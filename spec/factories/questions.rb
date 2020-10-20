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
  end
end
