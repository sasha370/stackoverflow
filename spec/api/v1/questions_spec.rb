require 'rails_helper'

describe 'Questions API', type: :request do

  let(:headers) { {'CONTENT_TYPE' => 'application/json',
                   'ACCEPT' => 'application/json'} }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }

      before { get api_path, params: {access_token: access_token.token}, headers: headers }

      it 'return 200 status' do
        expect(response).to be_successful
      end

      it 'return list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns public fields' do
        %w[id title body created_at updated_at user_id].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end
    end
  end

  describe 'GET /api/v1/questions' do
    let!(:question) { create(:question, :with_file) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_responce) { json['question'] }
      let!(:answers) { create_list(:answer, 3, question: question) }
      let!(:comments) { create_list(:comment, 3, commentable_type: 'Question', commentable_id: question.id) }

      before { get api_path, params: {id: question.id, access_token: access_token.token}, headers: headers }

      it 'return 200 status' do
        expect(response).to be_successful
      end

      it 'return list of questions' do
        expect(['question'].size).to eq 1
      end

      it 'returns public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_responce[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_responce['user']['id']).to eq question.user.id
      end

      it 'contains list of answers' do
        expect(question_responce['answers'].size).to eq question.answers.count
        expect(question_responce['answers'].first['id']).to eq question.answers.first.id
        end

      it 'contains list of links' do
        expect(question_responce['links'].size).to eq question.links.count
        expect(question_responce['links'].first['id']).to eq question.links.first.id
      end

      it 'contains list of attachments' do
        expect(question_responce['files'].size).to eq question.files.count
        expect(question_responce['files'].first['id']).to eq question.files.first.id
      end

      it 'contains list of comments' do
        expect(question_responce['comments'].size).to eq question.comments.count
        expect(question_responce['comments'].first['id']).to eq question.comments.first.id
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
    end
  end

end
