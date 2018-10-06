class AddComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
    	t.text :text
    	t.integer :user_id
    	t.integer :movie_id
    	t.datetime :created_at
    end
  end
end
