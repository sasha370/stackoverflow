FactoryBot.define do
  factory :answer do
    body { "My Answer" }
    question

    trait :invalid do
      body { nil }
    end
  end
end
