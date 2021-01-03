RSpec.shared_examples 'ratinged' do

  context 'POST #thumb_up, #thumb_down' do
    before { login(user) }

    it 'create a new rating' do
      expect { post :thumb_up, params: { id: ratinged } }.to change(Rating, :count).by(1)
    end

    it 'create a new rating' do
      expect { post :thumb_down, params: { id: ratinged } }.to change(Rating, :count).by(1)
    end
  end

  context 'POST #cancel_voice' do
    before do
      login(user)
      ratinged.vote_plus(user)
    end

    it 'destroy rating' do
      expect { post :cancel_voice, params: { id: ratinged } }.to change(Rating, :count).by(-1)
    end
  end
end
