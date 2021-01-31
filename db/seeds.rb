admin = User.create!(email: 'admin@admin.ru', password: '123456', confirmed_at: Time.now, admin: true)
rewards = ['spec/fixtures/files/reward_1.jpg',
           'spec/fixtures/files/reward_2.jpg',
           'spec/fixtures/files/reward_3.jpg']

#Create Test Users
users = []
10.times do |i|
  users << User.create(email: "test#{i}@test.ru", password: '123456', confirmed_at: Time.now)
end

#Create Questions
questions = []
10.times do
  questions << Question.create(
      user: users.sample,
      title: Faker::Movies::Hobbit.quote,
      body: Faker::Lorem.sentence(word_count: 30)
  )
end

#Create Answers for Questions
questions.each do |question|
  rand(2..6).times do
    Answer.create(
        question: question,
        user: users.sample,
        body: Faker::Movies::Hobbit.quote,
    )
  end

  #Set random answer inside question as BEST
  question.answers.sample.set_best

  #Create Comments for Question
  rand(0..3).times do
    question.comments.create(
        user: users.sample,
        body: Faker::Quote.famous_last_words
    )
  end
end

# Create rewards for some Questions
10.times do
  reward = Reward.new(title: Faker::Movies::Hobbit.location)
  reward.image.attach(io: File.open(rewards.sample), filename: 'file for reward')
  reward.question = questions.sample
  reward.save
end

#Create Attachment for some Questions
10.times do
  questions.sample.files.attach(io: File.open(rewards.sample), filename: 'file for question')
end

#Create Attachment for some Answer
20.times do
  Answer.all.sample.files.attach(io: File.open(rewards.sample), filename: 'file for answer')
end


#Create comments for answers
answers = Answer.all
answers.each do |answer|
  rand(0..3).times do
    answer.comments.create(
        user: users.sample,
        body: Faker::Quote.famous_last_words
    )
  end
end

#Create sample links for Question
5.times do
  questions.sample.links.create(
      name: 'test gist link',
      url: 'https://gist.github.com/sasha370/495b589c32b357d20a3e46f29aeb54c0'
  )
  questions.sample.links.create(
      name: 'this is simple test link',
      url: 'https://github.com/sasha370/stackoverflow')
end

#Create sample links for Answers
20.times do
  answers.sample.links.create(
      name: 'test gist link',
      url: 'https://gist.github.com/sasha370/495b589c32b357d20a3e46f29aeb54c0'
  )
  answers.sample.links.create(
      name: 'this is simple test link',
      url: 'https://github.com/sasha370/stackoverflow')
end

#Simulate rating foe Questions
50.times { questions.sample.vote_plus(users.sample) }
20.times { questions.sample.vote_minus(users.sample) }

#Simulate rating foe Answers
50.times { answers.sample.vote_plus(users.sample) }
20.times { answers.sample.vote_minus(users.sample) }

puts "Seeds was successfully created"
