RSpec.shared_examples 'commented' do

  context 'POST #add_comment' do
    before { login(user) }

    it 'create a new comment' do
      expect { post :add_comment, params: { id: commented, comment: { body: 'Test Commit' }, format: :js } }.to change(Comment, :count).by(1)
    end
  end

  context 'DELETE #destroy_comment' do
    before do
      login(user)
    end

    let!(:comment) { commented.comments.create(body: 'Test commit', user: user) }

    it 'destroy comment' do
      expect { delete :destroy_comment, params: { id: commented.id , comment_id: comment.id }, format: :js  }.to change(Comment, :count).by(-1)
    end
  end
end
