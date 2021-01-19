require 'rails_helper'

describe 'Questions API', type: :request do

  let(:headers) { {'ACCEPT' => 'application/json'} }

  describe 'GET /api/v1/questions/:id/answers' do
    let!(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 3, question: question) }
      let(:answer_response) { json['answers'].first }

      before { get api_path, params: {access_token: access_token.token}, headers: headers }

      it 'return 200 status' do
        expect(response).to be_successful
      end

      it 'return list of answers' do
        expect(json['answers'].size).to eq 3
      end

      it 'returns public fields' do
        %w[id body created_at updated_at user_id question_id].each do |attr|
          expect(answer_response[attr]).to eq answers.first.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, :with_file, question: question) }
    let!(:comments) { create_list(:comment, 3, commentable_type: 'Answer', commentable_id: answer.id) }
    let(:answer_responce) { json['answer'] }

    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { get api_path, params: {access_token: access_token.token}, headers: headers }

      it 'return 200 status' do
        expect(response).to be_successful
      end

      it 'return answer' do
        expect(['answer'].size).to eq 1
      end

      it 'returns public fields' do
        %w[id body created_at updated_at question_id best].each do |attr|
          expect(answer_responce[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(answer_responce['user']['id']).to eq answer.user.id
      end

      it 'contains list of links' do
        expect(answer_responce['links'].size).to eq answer.links.count
        expect(answer_responce['links'].first['id']).to eq answer.links.first.id
      end

      it 'contains list of attachments' do
        expect(answer_responce['files'].size).to eq answer.files.count
        expect(answer_responce['files'].first['id']).to eq answer.files.first.id
      end

      it 'contains list of comments' do
        expect(answer_responce['comments'].size).to eq answer.comments.count
        expect(answer_responce['comments'].first['id']).to eq answer.comments.first.id
      end
    end
  end
end
# describe 'answers' do
#   let(:answer) { answers.first }
#   let(:answer_response) { question_response['answers'].first }
#
#   it 'return list of answers' do
#     expect(question_response['answers'].size).to eq 3
#   end
#
#   it 'returns public fields' do
#     %w[id body user_id created_at updated_at].each do |attr|
#       expect(answer_response[attr]).to eq answer.send(attr).as_json
#     end
#   end
# end
