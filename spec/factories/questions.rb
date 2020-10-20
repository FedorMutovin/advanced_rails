FactoryBot.define do
  sequence :title do |n|
    "qt#{n}"
  end
  sequence :body do |n|
    "qb#{n}"
  end
  factory :question do
    title
    body

    trait :invalid do
      title { nil }
    end
  end
end
