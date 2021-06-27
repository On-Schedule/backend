class CreateWorkDays < ActiveRecord::Migration[5.2]
  def change
    create_table :work_days do |t|
      t.references :project, foreign_key: true
      t.references :day_of_week, foreign_key: true

      t.timestamps
    end
  end
end
