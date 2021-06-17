class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.references :company, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.string :name
      t.integer :hours_per_day

      t.timestamps
    end
  end
end
