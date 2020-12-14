FactoryBot.define do
  factory :answer do
    body { "My Answer" }
    question
    user
    trait :invalid do
      body { nil }
    end
  end
end
