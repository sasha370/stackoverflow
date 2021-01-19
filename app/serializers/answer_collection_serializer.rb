class AnswerCollectionSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :user_id, :best, :question_id
end
