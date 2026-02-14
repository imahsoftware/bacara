jQuery ->
	$(document).on 'click', '.edit_userspermiso_button, #new_userspermiso_button', (e) ->
		e.preventDefault()
		id = $('.active_userspermiso').data('target')
		$.get $(this).attr('href'), active_id: id
