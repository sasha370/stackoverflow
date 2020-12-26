class CreateRatings < ActiveRecord::Migration[6.0]
  def change
    create_table :ratings do |t|
      t.integer :vote
      t.belongs_to :user
      t.references :ratingable, polymorphic: true
      t.timestamps
    end
  end
end
