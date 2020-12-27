require 'rails_helper'

RSpec.shared_examples_for 'ratingable' do

  it 'should create rating with vote = 1' do
    expect { model.vote_plus(user) }.to change(Rating, :count).by(1)
    expect(model.ratings.first.vote).to eq 1
  end

  it 'should create rating with vote = 1' do
    expect { model.vote_minus(user) }.to change(Rating, :count).by(1)
    expect(model.ratings.first.vote).to eq -1
  end

  it 'should cancel rating = remove it' do
    model.vote_plus(user)
    expect { model.cancel_voice(user) }.to change(Rating, :count).by(-1)
  end

  it 'should correctly back a rating' do
    expect { model.vote_plus(user) }.to change { model.rating }.by(1)
  end
end
