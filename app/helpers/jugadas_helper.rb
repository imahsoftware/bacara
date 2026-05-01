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
end
