FactoryBot.define do
  factory :rating do
    vote { false }
    question { nil }
    answer { nil }
  end
end
