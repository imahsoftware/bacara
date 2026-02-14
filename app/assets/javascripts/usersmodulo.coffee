jQuery ->
	$(document).on 'click', '.edit_usersmodulo_button, #new_usersmodulo_button', (e) ->
		e.preventDefault()
		id = $('.active_usersmodulo').data('target')
		$.get $(this).attr('href'), active_id: id
