jQuery ->
  $(document).on 'change', '#user_username', ->
    user_username = @value
    $.get('/users/pre_otp', { username: user_username })