require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_length_of(:title).is_at_least(5) }
  it { should validate_presence_of :body }
  it { should have_many(:answers) }
  it { should have_one(:reward).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:ratings).dependent(:destroy) }
  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :reward }
  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  let(:user){create(:user)}
  let(:question){create(:question, user: user)}

  it 'should create rating with vote = 1' do
    expect{question.vote_plus}.to change(Rating, :count).by(1)
    expect(question.ratings.first.vote).to eq 1
  end

  it 'should correctly back a rating' do
    expect{question.vote_plus}.to change{question.rating}.by(1)
  end

end
