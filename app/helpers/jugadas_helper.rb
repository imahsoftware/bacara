module JugadasHelper
  def format_jugada_profit_value(v)
    iv = v.to_f
    str = iv == iv.to_i ? iv.to_i.to_s : sprintf('%.1f', iv)
    iv > 0 ? "+#{str}" : str
  end

  # Agrupa jugadas del mismo día por user_id; totales con profit_by_jugada_id[jugada_id] (sum acumuladof).
  def jugadas_consolidado_rows_for_dia(jugadas_del_dia, profit_by_jugada_id)
    return [] if jugadas_del_dia.blank?

    jugadas_del_dia.group_by(&:user_id).map do |_uid, lista|
      u = lista.first.user
      total = lista.sum { |j| profit_by_jugada_id[j.id].to_f }
      { user: u, count: lista.size, total: total }
    end.sort_by { |r| [-r[:total], (r[:user]&.username).to_s.downcase] }
  end

  # Igual que jugadas_consolidado_rows_for_dia, pero separado por denominación (moneda):
  # con varias monedas el mismo día no tiene sentido sumar sus totales juntos, así que se
  # arma un grupo (tabla + gráfico) independiente por cada denominación presente.
  def jugadas_consolidado_groups_for_dia(jugadas_del_dia, profit_by_jugada_id)
    return [] if jugadas_del_dia.blank?

    jugadas_del_dia.group_by(&:denominacion).map do |den, lista|
      { denominacion: den, rows: jugadas_consolidado_rows_for_dia(lista, profit_by_jugada_id) }
    end.sort_by { |g| (g[:denominacion]&.codigo).to_s }
  end

  # Totales del día separados por denominación (mismo motivo que arriba).
  def jugadas_day_totals_by_currency(jugadas_del_dia, profit_by_jugada_id)
    return [] if jugadas_del_dia.blank?

    jugadas_del_dia.group_by(&:denominacion).map do |den, lista|
      { denominacion: den, amt: lista.sum { |j| profit_by_jugada_id[j.id].to_f } }
    end.sort_by { |h| (h[:denominacion]&.codigo).to_s }
  end

  # Un badge coloreado por cada moneda (ver jugadas_day_totals_by_currency). Con una sola
  # moneda queda igual que antes (un solo valor); con varias, uno junto al otro.
  def jugadas_day_total_badges(day_totals)
    safe_join(day_totals.map { |h|
      amt     = h[:amt].to_f
      cls     = amt > 0 ? 'jd-profit-pos' : (amt < 0 ? 'jd-profit-neg' : 'jd-profit-zero')
      simbolo = h[:denominacion]&.simbolo
      texto   = format_jugada_profit_value(amt)
      texto   = "#{simbolo} #{texto}" if simbolo.present?
      content_tag(:span, texto, class: "jugadas-day-total-badge #{cls}")
    })
  end
end
