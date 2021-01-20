FactoryBot.define do
  factory :comment do
    body { "MyString" }
    user
    commentable_id { nil }
    commentable_type { nil }
  end
end
