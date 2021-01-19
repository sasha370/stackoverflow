class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at
  has_many :links
  has_many :files, each_serializer: AttachmentSerializer
  has_many :comments
  has_many :answers
  belongs_to :user
end
