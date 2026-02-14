jQuery ->
	$(document).on 'click', '.edit_usersvehiculo_button, #new_usersvehiculo_button', (e) ->
		e.preventDefault()
		id = $('.active_usersvehiculo').data('target')
		$.get $(this).attr('href'), active_id: id
