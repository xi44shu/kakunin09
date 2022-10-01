class StartTime < ActiveHash::Base
  self.data = [
    { id: 1, name: '後で選択' },
    { id: 2, name: '~8:00' },
    { id: 3, name: '9:00' },
    { id: 4, name: '10:00' },
    { id: 5, name: '11:00' },
    { id: 6, name: '12:00' },
    { id: 7, name: '13:00' },
    { id: 8, name: '14:00' },
    { id: 9, name: '15:00~' },
    { id: 10, name: '20:00' },
    { id: 11, name: '21:00' },
    { id: 12, name: '22:00' },
    { id: 13, name: '23:00~' },
  ]

  include ActiveHash::Associations
  has_many :schedules

end
