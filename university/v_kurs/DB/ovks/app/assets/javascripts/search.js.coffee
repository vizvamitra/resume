# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'page:change', ->
  $('.search_button').click (event) ->
    event.preventDefault()
    if ( $('.search_button').parent().find('input[type=text]').val() != '' )
      $('.search_button').parent().submit()