$(document).ready ->
  # select lang
  $('ul#menu-lang li a').click (e)->
    e.preventDefault()
    lang = $(this).parent().data('lang')
    Control.cookie_set('lang', lang, 365)
    window.location.reload()
