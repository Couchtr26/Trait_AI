class CreateUserMemories < ActiveRecord::Migration[8.1]
  def change
    create_table :user_memories do |t|
      t.references :user, null: false, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
