class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.references :company, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest
      t.string :api_key

      t.timestamps
    end
  end
end
