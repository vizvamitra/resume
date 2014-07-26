# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'page:change', ->
  $('#bill_pos_form #form_submit').click(submit_form)
  $('.bp_form input[type="radio"]').click(reload_szs_nzs)

submit_form = ->
  type_id = $('#form_type_id').val()
  model = $('#form_model').val()
  count = $('#form_count').val()
  sn = $('#form_sn').val()
  bill = $('#form_bill_id').val()

  if (model != "")
    $.ajax({
      url: bill+'/bill_positions',
      type: 'POST',
      data: {bill_position: {type_id: type_id, model: model, count: count, sn: sn}}
    })

reload_szs_nzs = ->
  if ($('#bp_radio_sz').is(':checked'))
    type = 'sz'
    url = '/szs/not_done'
  else
    type = 'nz'
    url = '/nzs/not_done'

  select = $('#sz_nz_select').attr('name', 'bill_position['+type+'_id]')

  $.ajax({
    url: url,
    method: 'GET'
  }).done (json) ->    
    select.find('option:gt(0)').remove()
    json.forEach (elem)->
      select.append("<option value='"+elem['id']+"'>"+elem['ovks_num']+"</option>")
  #$('#sz_nz_select').