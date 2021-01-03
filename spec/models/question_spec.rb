require 'rails_helper'
require_relative './concerns/ratingable_spec'

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

  it_behaves_like 'ratingable' do
    let!(:another_user) { create(:user) }
    let(:user) { create(:user) }
    let(:model) { create(:question, user: another_user) }
  end
end
