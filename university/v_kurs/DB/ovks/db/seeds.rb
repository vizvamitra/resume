# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Bill.create!([{
    ovks_num: '001/14',
    bill_num: 'КСВ0004975',
    bill_date: DateTime.now,
    vendor_id: 1,
    total_sum: 1549.05
  },
  {
    ovks_num: '002/14',
    bill_num: 'КСВ0004976',
    bill_date: DateTime.now,
    vendor_id: 2,
    total_sum: 1537.05
  }
])

Bill_position.create!([{
  type_id: 1,
  model: "Asus eee pc 123",
  count: "1",
  sn: "",
  bill_id: 1,
  user_id: 1
}])

Vendor.create!([{
    title: 'РАМЭК-ВС, ЗАО',
    address: 'ул.Чёрт-знает-кого',
    phone: '890464135500',
    note: 'Владислав'
  },
  {
    title: 'Ками, ЗАО',
    address: 'г.Москва',
    phone: '734539847',
    note: 'Сергей'
}])

User.create!([{
    login: 'kaktus',
    password: '197136',
    password_confirmation: '197136',
    fio: 'Горина Екатерина Сергеевна'
  },
  {
    login: 'sasha',
    password: '197136',
    password_confirmation: '197136',
    fio: 'Ивашов Александр Юрьевич'
}])


