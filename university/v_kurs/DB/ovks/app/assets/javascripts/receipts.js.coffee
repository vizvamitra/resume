# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'page:change', ->
  $('#print_link').remove()
  if (window.location.pathname.match(/^\/receipts\/\d+$/))
    print = $("<a href='#'id='print_link'>Печать</a>")
    $('#controls').append(print)
    $('#print_link').click (event) ->
      event.preventDefault()
      window.print()