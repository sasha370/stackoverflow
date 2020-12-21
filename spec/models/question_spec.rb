require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_length_of(:title).is_at_least(5) }
  it { should have_many(:answers) }
  it { should validate_presence_of :body }
  it { should have_many(:answers).dependent(:destroy) }
  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
