class TimeZone < ActiveHash::Base
  self.data = [
    { id: 1, name: '---' },
    { id: 2, name: '午前' },
    { id: 3, name: '午後' },
    { id: 4, name: '夜間' },
    { id: 5, name: 'その他' },
  ]


end