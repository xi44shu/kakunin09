class CreateTradingCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :trading_companies do |t|
      t.string :tc_name,           null:false
      t.string :tc_contact_person, null:false
      t.string :tc_telephone,      null:false
      t.timestamps
    end
  end
end
