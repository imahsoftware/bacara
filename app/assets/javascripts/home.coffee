# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
	# $(document).on 'focusout', '.input_uppercase', ->
# 		$(this).val(@value.toUpperCase())

  $('.select2').select2()

	$(document).on 'click', '.popup', (e) ->
		e.preventDefault();
		window.open(this.href, 'new_window', 'height=600,width=900,scrollbars=yes');

	$(document).on 'click', '.popup_rotulo', (e) ->
		e.preventDefault();
		window.open(this.href, 'new_window', 'height=300,width=600,scrollbars=yes');

	$(document).on 'click', '.popup2', (e) ->
		e.preventDefault();
		window.open(this.href, 'new_window', 'height=600,width=1000,scrollbars=yes');

	$(document).on 'click', '.cancel_button', ->
		target = $(this).data('target')
		$(target).collapse('hide')
		$(target).empty()
