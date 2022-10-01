class CreateSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :schedules do |t|
      t.date :scheduled_date,        null: false
      t.integer :time_zone_id,       null: false
      t.references :team,            null: false, foreign_key: true
      t.references :user,            null: false, foreign_key: true
      t.integer :accuracy_id,        null: false
      t.integer :size_id,            null: false
      t.integer :mie_id,             null: false
      t.integer :first_contact_id,   null: false
      t.references :trading_company, foreign_key: true
      t.integer :start_time_id
      t.text :prime_contractor
      t.text :content
      t.timestamps
    end
  end
end
