FactoryBot.define do
  factory :reward do
    title { "for best answer" }
    image { "#{Rails.root}/spec/fixtures/files/image.jpg" }
    question

    trait :invalid do
      image {}
    end
  end
end
