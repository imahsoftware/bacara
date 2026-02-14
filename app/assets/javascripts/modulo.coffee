jQuery ->
	$(document).on 'click', '.edit_modulo_button, #new_modulo_button', (e) ->
		e.preventDefault()
		id = $('.active_modulo').data('target')
		$.get $(this).attr('href'), active_id: id
