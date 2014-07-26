module ApplicationHelper
  def fio
    session[:user_name]
  end

  def current_date
    date = Time.now
    days = {  0 => 'Воскресенье',
              1 => 'Понедельник',
              2 => 'Вторник',
              3 => 'Среда',
              4 => 'Четверг',
              5 => 'Пятница',
              6 => 'Суббота'
            }
    day = days[ date.wday ]
    "#{day}, #{ date.strftime("%d.%m.%Y") }"
  end

  def date(date)
    date.strftime("%d.%m.%Y") if date
  end

  def first_name str
    str.split(' ')[0]
  end

  def sz_nz_path(item)
    if item.is_a?(Item)
      if item.sz_id
        sz_path(item.sz)
      else
        nz_path(item.nz)
      end
    elsif item.is_a?(Sz) || item.is_a?(Nz)
      sz_path(item)
    end
  end

  def representation obj
    if [Bill, Sz, Nz, Receipt].include? obj.class
      link_to obj.ovks_num, obj
    elsif obj.is_a? BillPosition
      link_to obj.bill.ovks_num, bill_url(obj.bill_id)
    elsif obj.is_a? Item
      link_to obj.reason.ovks_num, obj.reason
    elsif obj.is_a? Employee
      "#{obj.department.title}, т. #{obj.phone}"
    end
  end

  def object_type obj
    types = {
      Bill => 'Счёт',
      Nz => 'Наряд-заказ',
      Sz => 'Служебная записка',
      BillPosition => 'Позиция по счёту',
      Item => 'Номенклатура',
      Receipt => 'Расписка',
      Employee => 'Сотрудник'
    }

    types[obj.class]
  end

end
