FactoryBot.define do
  factory :question do
    title { "My Question Title" }
    body { "My Question Body" }
    user

    after :create do |q|
      create_list :question_link, 3, linkable_id: q.id
    end

    trait :invalid do
      title { nil }
    end

    trait :with_file do
      files { [Rack::Test::UploadedFile.new("spec/fixtures/files/image.jpg", 'img/jpg'),
               Rack::Test::UploadedFile.new("spec/fixtures/files/image.jpg", 'img/jpg')
      ] }
    end
  end
end
