require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }
    before do
      question.files.attach(create_file_blob)
      login(question.user)
    end

    it 'delete the attachment file' do
      expect { delete :destroy, params: { id: question.files[0] }, format: :js }.to change(question.files, :count).by(-1)
    end

    it 'render delete_attachment' do
      delete :destroy, params: { id: question.files[0] }, format: :js
      expect(response).to render_template :destroy
    end

    context 'NOT Author of question' do
      before { login(another_user) }
      it 'can`t delete attachment' do
        expect { delete :destroy, params: { id: question.files[0] }, format: :js }.to change(question.files, :count).by(0)
      end
    end
  end
end
