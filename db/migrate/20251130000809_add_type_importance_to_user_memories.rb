class AddTypeImportanceToUserMemories < ActiveRecord::Migration[8.1]
  def change
    add_column :user_memories, :memory_type, :string
    add_column :user_memories, :importance, :integer
  end
end
