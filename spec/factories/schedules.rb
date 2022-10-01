FactoryBot.define do
  factory :schedule do
    scheduled_date   { (Date.today)+1 }       
    time_zone_id     { '2' }       
    accuracy_id      { '2' }        
    size_id          { '2' }            
    mie_id           { '2' }             
    first_contact_id { '2' }   
    start_time_id    { '2' }             
    prime_contractor { Faker::Lorem.sentence }
    content          { Faker::Lorem.sentence }
    association :user
    association :team
    association :trading_company
  end
end
