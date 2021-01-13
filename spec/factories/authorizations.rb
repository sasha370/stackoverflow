FactoryBot.define do
  factory :authorization do
    user { nil }
    provider { "Provider" }
    uid { "123456" }
  end
end
