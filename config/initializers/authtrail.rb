# AuthTrail: registra cada intento de login (exitoso o fallido) en la tabla
# login_activities, incluyendo la IP pública desde donde se conecta el usuario.
#
# BUG ENCONTRADO: en authtrail 0.2.1 NO existe `transform_method` (se agregó
# hasta 0.2.2). Lo que sí existe es `track_method`, pero su comportamiento es
# distinto: cuando se define, AuthTrail deja de guardar el LoginActivity por
# su cuenta y delega TODO el guardado a este lambda. Ademas recibe un solo
# argumento (data), no (data, request).
#
# El lambda anterior se definía como `do |data, request|` y solo calculaba
# data[:ip] sin guardar nada -> nunca se creaba el registro en
# login_activities (por eso "No connection records yet." aunque
# current_sign_in_ip sí se actualizaba, ya que eso lo maneja Devise
# directamente, no AuthTrail).
#
# AuthTrail ya calcula data[:ip] = request.remote_ip, el cual respeta
# config.action_dispatch.trusted_proxies / X-Forwarded-For (por eso
# current_sign_in_ip de Devise ya muestra la IP pública correcta:
# 177.253.222.147). Aquí solo completamos el guardado del registro.

AuthTrail.geocode = false

AuthTrail.track_method = lambda do |data|
  LoginActivity.create!(data)
end