class AddUserRefToQuestionsAndAnswers < ActiveRecord::Migration[6.0]
  def change
    add_reference :questions, :user, null: false, foreign_key: true
    change_column_null :answers, :question_id, false
    add_reference :answers, :user, null: false, foreign_key: true
  end
end
