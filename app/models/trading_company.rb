class TradingCompany < ApplicationRecord
  with_options presence: true do
    validates :tc_name, :tc_contact_person
    validates :tc_telephone, format: { with: /\A[0-9]{10,11}\z/ }
  end
  has_many :schedules

end
