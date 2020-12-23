FactoryBot.define do
  factory :link do
    name { "gist_url" }
    url { "https://gist.githu0b.com/sasha370/370381473ad4e3cd5fc9eda5691b3c43" }

    trait :wrong_link do
      name { "wrong_url" }
      url { "https://gist.githudd.yy" }
      end
    trait :gist do
      name { "Gist" }
      url { "https://gist.github.com/sasha370/370381473ad4e3cd5fc9eda5691b3c43.js" }
    end
  end
end
