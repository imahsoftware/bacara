jQuery ->
	$(document).on 'click', '.edit_objeto_button, #new_objeto_button', (e) ->
		e.preventDefault()
		id = $('.active_objeto').data('target')
		$.get $(this).attr('href'), active_id: id
