class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.datetime :cooldown_until
      t.integer :empathy
      t.integer :logic
      t.integer :curiosity
      t.integer :humor
      t.integer :calmness

      t.timestamps
    end
  end
end
