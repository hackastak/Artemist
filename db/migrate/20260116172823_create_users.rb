class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :github_uid
      t.string :github_username
      t.string :avatar_url

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
