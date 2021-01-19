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
    let(:answer_response) { json['answer'] }

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
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(answer_response['user']['id']).to eq answer.user.id
      end

      it 'contains list of links' do
        expect(answer_response['links'].size).to eq answer.links.count
        expect(answer_response['links'].first['id']).to eq answer.links.first.id
      end

      it 'contains list of attachments' do
        expect(answer_response['files'].size).to eq answer.files.count
        expect(answer_response['files'].first['id']).to eq answer.files.first.id
      end

      it 'contains list of comments' do
        expect(answer_response['comments'].size).to eq answer.comments.count
        expect(answer_response['comments'].first['id']).to eq answer.comments.first.id
      end
    end
  end

  describe 'POST /api/v1/questions/:id/answers' do
    let!(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:answer_attr) { attributes_for(:answer) }
      let(:answer_attr_incorrect) { {body: ''} }
      let(:answer_response) { json['answer'] }

      context 'with correct data' do
        before { post api_path, params: {answer: answer_attr, access_token: access_token.token}, headers: headers }

        it 'return 200 status' do
          expect(response).to be_successful
        end

        it 'save answer in DB' do
          expect { post api_path, params: {answer: answer_attr, access_token: access_token.token}, headers: headers }.to change(Answer, :count).by(1)
        end

        it 'return answer' do
          expect(['answer'].size).to eq 1
        end

        it 'return answer with correct user' do
          expect(answer_response['user']['id']).to eq user.id
        end

        it 'returns correct fields' do
          expect(answer_response['body']).to eq answer_attr[:body]
        end
      end

      context 'with incorrect data' do

        before { post api_path, params: {answer: answer_attr_incorrect, access_token: access_token.token}, headers: headers}

        it 'don`t save question in DB' do
          expect { post api_path, params: {answer: answer_attr_incorrect, access_token: access_token.token}, headers: headers}.to_not change(Answer, :count)
        end

        it 'return 422 status' do
          expect(response).to have_http_status(422)
        end
      end
    end
  end
end

