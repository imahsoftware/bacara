jQuery ->
	$(document).on 'click', '.edit_userssucursal_button, #new_userssucursal_button', (e) ->
		e.preventDefault()
		id = $('.active_userssucursal').data('target')
		$.get $(this).attr('href'), active_id: id
