FactoryBot.define do
  factory :question do
    title { "My Question Title" }
    body { "My Question Body" }
    user

    trait :invalid do
      title { nil }
    end
  end
end
