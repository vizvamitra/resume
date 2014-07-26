# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->  # В момент окончания загрузки страницы ...
  $("#new_user input[type='submit']").click(login) # Ставим кнопке "Войти" свой обработчик клика


login = (event) ->
  event.preventDefault() # Предотвращает отправку формы (отправим после проверки сами)
  $("#errors").html("") # Очищаем блок ошибок
  errors = false
  
  form = $("#new_user") # Получаем объект формы
  
  login = form.find("input[name='user[login]']").val() # Ищем в форме поле логина и получаем
                            # введённое в него пользователем значение
  if ( login == '' )
    addError('Не указан логин')
    errors = true  # Если была ошибка, запомним это

  # TODO: Добавить проверку на наличие левых символов
  
  pass = form.find("input[name='user[password]']").val()
  if ( pass == '' )
    addError('Не указан пароль')
    errors = true
    
  if (!errors)    # Если не было ошибок, 
    form.submit()  # Отправляем форму, когда всё проверено


addError = (message) ->
  error = $('<p></p>')   # Создаём повый параграф (<p></p>)
  error.text(message)    # Вставляем в него текст
  $('#errors').append(error) # Добавляем параграф на страницу в блок ошибок