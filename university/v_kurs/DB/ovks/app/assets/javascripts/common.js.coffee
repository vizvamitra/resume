$(document).on 'page:change', ->
  $('.fixed_header').each ->
    $(this).fix_header()

$.fn.fix_header = ->
  table = $(this)
  min_offset = table.offset().top - $('#top').outerHeight() + $('#main').scrollTop()
  header = table.find('thead')

  initial_widths = []
  header.find('tr:first-child th').each ->
    initial_widths.push($(this).width())

  margin = parseInt(table.css('margin-top')) || 0
  fix_height = $('.padding_fix').height()

  $('#main').scroll ->
    header.switch_fixed(min_offset, margin, fix_height)
    header.fix_vertical()
    fix_width(initial_widths, header, table)
    
  $.fn.switch_fixed = (min_offset, margin, fix_height) ->
    table = this.parent()    
    if ($('#main').scrollTop() > min_offset)
      if ( !this.hasClass('fixed') )
        $('.padding_fix').css('height', fix_height + this.outerHeight(), 'important')
        table.css('margin-top', margin + this.outerHeight(), 'important')
        this.addClass('fixed')        
    else
      if ( this.hasClass('fixed') )
        table.css('margin-top', margin, 'important')
        $('.padding_fix').css('height', fix_height, 'important')
        this.removeClass('fixed')

  $.fn.fix_vertical = ->
    this.css('top', $('#main').scrollTop())

  fix_width = (initial, header, table) ->
    ths = header.find('th')
    tds = table.find('td')
    initial.forEach (value, index) ->
      $(ths[index]).css('min-width', value)
      $(tds[index]).css('min-width', value)

@submit_item_form = (event) ->
  event.preventDefault()
  type_id = $('#form_type_id').val()
  count = $('#form_count').val()
  name = $('#form_name').val()
  info = $('#form_info').val()
  done_info = $('#form_done_info').val()
  sz_nz = event.data.sz_nz

  if (sz_nz == 'sz')
    id = $('#form_sz_id').val()
  else if (sz_nz == 'nz')
    id = $('#form_nz_id').val()

  if (id && name)
    params = {count: count, item: {type_id: type_id, name: name, info: info, done_info: done_info}}
    params[sz_nz] = id
    $.ajax({
      url: '/items',
      type: 'POST',
      data: params
    })