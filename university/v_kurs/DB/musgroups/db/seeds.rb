# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Group.delete_all
Group.create!(id:1, title: 'Deep Purple', formation_year:1968, country:'Великобритания', top_position:1)
Group.create!(id:2, title: 'Metallica', formation_year:1981, country:'США', top_position:2)
Group.create!(id:3, title: 'Megadeth', formation_year:1983, country:'США', top_position:3)
Group.create!(id:4, title: 'Scorpions', formation_year:1965, country:'Германия', top_position:4)
Group.create!(id:5, title: 'Nightwish', formation_year:1996, country:'Финляндия', top_position:5)
Group.create!(id:6, title: 'Blackmore’s Night', formation_year:1997, country:'США', top_position:6)

Member.delete_all
Member.create!(name: 'Ian Gillan', role:'Вокал', birth_date:'1945-08-19 00:00:00', group_id:1)
Member.create!(name: 'Steven J. Morse', role:'Гитара', birth_date:'1954-07-24 00:00:00', group_id:1)
Member.create!(name: 'Roger David Glover', role:'Бас-гитара', birth_date:'1945-11-30 00:00:00', group_id:1)
Member.create!(name: 'Don Airey', role:'Клавиши', birth_date:'1948-06-21 00:00:00', group_id:1)
Member.create!(name: 'Ian Anderson Paice', role:'Ударные', birth_date:'1948-06-29 00:00:00', group_id:1)

Song.delete_all
Song.create!(title:'Highway Star', music_by:'', lyrics_by:'', group_id:1)
Song.create!(title:'Maybe I\'m A Leo', music_by:'', lyrics_by:'', group_id:1)
Song.create!(title:'Pictures Of Home', music_by:'', lyrics_by:'', group_id:1)
Song.create!(title:'Never Before', music_by:'', lyrics_by:'', group_id:1)
Song.create!(title:'Smoke On The Water', music_by:'', lyrics_by:'', group_id:1)
Song.create!(title:'Lazy', music_by:'', lyrics_by:'', group_id:1)
Song.create!(title:'Space Truckin', music_by:'', lyrics_by:'', group_id:1)

Tour.delete_all
Tour.create!(id:1, title:'Now What?! World Tour', group_id:1)
Tour.create!(id:2, title:'Dummy', group_id:1)

Concert.delete_all
Concert.create!(country:'ОАЭ', city:'Дубай', date:'2013-01-21',tour_id:1)
Concert.create!(country:'Новая Зеландия', city:'Окленд', date:'2013-01-24',tour_id:1)
Concert.create!(country:'Австралия', city:'Брисбен', date:'2013-01-26',tour_id:1)
Concert.create!(country:'Австралия', city:'Мельбурн', date:'2013-03-01',tour_id:1)
Concert.create!(country:'Австралия', city:'Сидней', date:'2013-03-02',tour_id:1)
Concert.create!(country:'Австралия', city:'Аделаида', date:'2013-03-04',tour_id:1)
Concert.create!(country:'Австралия', city:'Перт', date:'2013-03-07',tour_id:1)
Concert.create!(country:'Сингапур', city:'Сингапур', date:'2013-03-12',tour_id:1)
Concert.create!(country:'Австрия', city:'Ишгль', date:'2013-04-30',tour_id:1)
Concert.create!(country:'Марокко', city:'Рабат', date:'2013-05-30',tour_id:1)
Concert.create!(country:'Болгария', city:'Каварна', date:'2013-05-02',tour_id:1)
Concert.create!(country:'Болгария', city:'Пловдив', date:'2013-05-03',tour_id:1)
Concert.create!(country:'Грузия', city:'Тбилиси', date:'2013-05-05',tour_id:1)
Concert.create!(country:'Исландия', city:'Рейкьявик', date:'2013-06-12',tour_id:1)
Concert.create!(country:'Германия', city:'Бонн', date:'2013-06-14',tour_id:1)
Concert.create!(country:'Швейцария', city:'Цюрих', date:'2013-06-15',tour_id:1)
Concert.create!(country:'Австрия', city:'Замок Клэм', date:'2013-06-17',tour_id:1)
Concert.create!(country:'Швейцария', city:'Монтрё', date:'2013-06-19',tour_id:1)
Concert.create!(country:'Италия', city:'Виджевано', date:'2013-06-21',tour_id:1)
Concert.create!(country:'Италия', city:'Рим', date:'2013-06-22',tour_id:1)
Concert.create!(country:'Италия', city:'Маяно', date:'2013-06-24',tour_id:1)
Concert.create!(country:'Монако', city:'Монте Карло', date:'2013-06-25',tour_id:1)
Concert.create!(country:'Испания', city:'Ойос-дель-Эспино', date:'2013-06-27',tour_id:1)
Concert.create!(country:'Польша', city:'Вроцлав', date:'2013-06-30',tour_id:1)
Concert.create!(country:'Германия', city:'Вакен', date:'2013-08-01',tour_id:1)
Concert.create!(country:'Венгрия', city:'Секешфехервар', date:'2013-08-03',tour_id:1)
Concert.create!(country:'Чехия', city:'Славков-у-Брна', date:'2013-08-04',tour_id:1)
Concert.create!(country:'Бельгия', city:'Локерен', date:'2013-08-06',tour_id:1)
Concert.create!(country:'Дания', city:'Ольборг', date:'2013-08-08',tour_id:1)
Concert.create!(country:'Швеция', city:'Евле', date:'2013-08-10',tour_id:1)
Concert.create!(country:'Франция', city:'Кольмар', date:'2013-08-13',tour_id:1)
Concert.create!(country:'Великобритания', city:'Манчестер', date:'2013-10-12',tour_id:1)
Concert.create!(country:'Великобритания', city:'Глазго', date:'2013-10-13',tour_id:1)
Concert.create!(country:'Великобритания', city:'Бигрингем', date:'2013-10-15',tour_id:1)
Concert.create!(country:'Великобритания', city:'Лондон', date:'2013-10-16',tour_id:1)
Concert.create!(country:'Великобритания', city:'Лондон', date:'2013-10-17',tour_id:1)
Concert.create!(country:'Нидерланды', city:'Зволле', date:'2013-10-19',tour_id:1)
Concert.create!(country:'Франция', city:'Париж', date:'2013-10-20',tour_id:1)
Concert.create!(country:'Германия', city:'Дрезден', date:'2013-10-22',tour_id:1)
Concert.create!(country:'Германия', city:'Эрфурт', date:'2013-10-24',tour_id:1)
Concert.create!(country:'Германия', city:'Рагенсбург', date:'2013-10-25',tour_id:1)
Concert.create!(country:'Германия', city:'Берлин', date:'2013-10-26',tour_id:1)
Concert.create!(country:'Германия', city:'Дюссельдорф', date:'2013-10-29',tour_id:1)
Concert.create!(country:'Германия', city:'Штутгарт', date:'2013-10-31',tour_id:1)
Concert.create!(country:'Германия', city:'Дортмунд', date:'2013-11-01',tour_id:1)
Concert.create!(country:'Германия', city:'Мангейм', date:'2013-11-02',tour_id:1)
Concert.create!(country:'Россия', city:'Москва', date:'2013-11-06',tour_id:1)
Concert.create!(country:'Россия', city:'Санкт-Петербург', date:'2013-11-08',tour_id:1)
Concert.create!(country:'Беларусь', city:'Минск', date:'2013-11-10',tour_id:1)
Concert.create!(country:'Украина', city:'Киев', date:'2013-11-12',tour_id:1)

Concert.create!(country:'Украина', city:'Киев', date:'2013-11-12',tour_id:2)