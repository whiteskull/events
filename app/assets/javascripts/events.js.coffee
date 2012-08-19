# Send form add-event by ajax
ajax_add_event = ->
  $('div#add-event form').submit (e)->
    e.preventDefault()

    $.ajax {
      url: $(this).attr('action'),
      type: $(this).attr('method'),
      data: $(this).serialize(),
      beforeSend: ->
        $('div#add-event form input[type="submit"]').prop('disabled', true);
      success: (data)->
        if parseInt(data) == 1
          window.location.reload()
        else
          $('div#add-event div.modal-body').html(data)
          ajax_add_event()
    }

# Send form edit-event by ajax
ajax_edit_event = ->
  $('div#edit-event form').submit (e)->
    e.preventDefault()

    $.ajax {
    url: $(this).attr('action'),
    type: $(this).attr('method'),
    data: $(this).serialize(),
    beforeSend: ->
      $('div#edit-event form input[type="submit"]').prop('disabled', true);
    success: (data)->
      if parseInt(data) == 1
        window.location.reload()
      else
        $('div#edit-event div.modal-body').html(data)
        ajax_edit_event()
    }

$(document).ready ->

  # Edit event
  $('table#calendar div.current p.my a, #events-day p.my a').click (e)->
    id = $(this).data('id')

    $.ajax {
      url: "/events/#{id}/edit",
      type: 'get',
      success: (data)->
        $('div#edit-event div.modal-body').html(data)
        ajax_edit_event()
    }

  # Add events
  $('table#calendar div.current div.add a, div#events-day p.add-day-event a').click (e)->
    day = $(this).data('day')
    month = $(this).data('month')
    year = $(this).data('year')
    lang = Control.cookie('lang')

    day = '0' + day if day < 10
    month = '0' + month if month < 10

    if lang == 'en'
      date = "#{year}.#{month}.#{day}"
    else
      date = "#{day}.#{month}.#{year}"

    $('div#add-event div.modal-header h3 span.date').text(date)

    $.ajax {
    	url: '/events/new',
    	type: 'get',
    	success: (data)->
        $('div#add-event div.modal-body').html(data)
        $('#event_when').val("#{year}-#{month}-#{day}")
        ajax_add_event()
    }

  # Hover on day
  $('table#calendar div.current').hover ->
    $('div.add', this).stop().animate top: '6px', 700
  , ->
    $('div.add', this).stop().animate top: '-40px', 700

  # Select date from calendar
  $('table#calendar div.date').on 'click', ->

    year = parseInt($('select#select-date_for-calendar_1i').val())
    month = parseInt($('select#select-date_for-calendar_2i').val())
    month_select = $(this).data('id')

    dt = new Date()
    year_current = dt.getFullYear()

    if ((year_current - 2) == year && month_select == 'last' && month == 1) || ((year_current + 5) == year && month_select == 'next' && month == 12)
      return false

    $('table#calendar div.date').off('click')

    day = parseInt($(this).text());

    switch month_select
      when 'last'
        if month == 1
          month = 12
          year--
        else
          month--
        console.log(year);
      when 'next'
        if month == 12
          month = 1
          year++
        else
          month++

    $('input#select-date_for-calendar_3i').val(day)
    $('select#select-date_for-calendar_2i').val(month)
    $('select#select-date_for-calendar_1i').val(year)
    $('form#select-date').submit()


