AuthTrail.geocode = false  # desactivar geocoding externo (evita llamadas lentas a APIs)

AuthTrail.transform_method = lambda do |data, request|
  # Capturar IP pública real, atravesando proxies/balanceadores
  # X-Forwarded-For puede tener múltiples IPs separadas por coma; la primera es la del cliente
  forwarded = request.env['HTTP_X_FORWARDED_FOR'].to_s.split(',').first.to_s.strip
  real_ip   = request.env['HTTP_X_REAL_IP'].to_s.strip

  data[:ip] = forwarded.presence || real_ip.presence || request.remote_ip.to_s
end
