# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'page:change', ->
  $('.add_receipt').off('click').click (add_receipt)


add_receipt = (event) ->
    event.preventDefault()
    $('.add_receipt').off('click').click (event) ->
      event.preventDefault()

    $('.receipt_checkbox_container').show()

    add = $("<a href='#' id='create_receipt'>Создать</a>")
    cancel = $("<a href='#' id='cancel_receipt'>Отмена</a>")
    $('#controls').append(cancel)
    $('#controls').append(add)
    
    cancel.click (event) ->
      event.preventDefault()
      $('.receipt_checkbox_container').hide()
      add.remove()
      cancel.remove()
      $('.add_receipt').click (add_receipt)

    add.click (event) ->
      event.preventDefault()
      ids = []
      $('.receipt_checkbox').each (index) ->
        if (this.checked)
          this.checked=false
          ids.push(this.value)
      
      if (ids.length > 0)
        request_str = '/receipts/new?'
        ids.forEach (id)->
          request_str += 'ids[]='+id+'&'
        window.location.replace(request_str);
        
