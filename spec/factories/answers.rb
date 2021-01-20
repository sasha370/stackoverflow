FactoryBot.define do
  factory :answer do
    body { "My Answer" }
    best { false }
    question
    user

    after :create do |answer|
      create_list :answer_link, 3, linkable_id: answer.id
    end

    trait :invalid do
      body { nil }
    end

    trait :with_file do
      files { [Rack::Test::UploadedFile.new("spec/fixtures/files/image.jpg", 'img/jpg'),
               Rack::Test::UploadedFile.new("spec/fixtures/files/image.jpg", 'img/jpg')
      ] }
    end
  end
end
