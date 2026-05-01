// Consolidado del día: filas colapsables + Highcharts "Profit by player".
// Vive en asset (no solo en partial) para que AJAX $.html() siga teniendo boot disponible.

(function () {
  function initHostsInRow(row) {
    if (!row || typeof row.querySelectorAll !== 'function') return;
    var fn = window.__jugadasInitConsolidadoChartHost;
    if (typeof fn !== 'function') return;
    row.querySelectorAll('.jugadas-consolidado-chart-host').forEach(fn);
  }

  function toggleDay(headerEl) {
    var target = headerEl.getAttribute('data-toggle-day');
    if (!target) return;
    var expanded = headerEl.getAttribute('aria-expanded') === 'true';
    var rows = document.querySelectorAll('tr.jugada-row.' + target);
    rows.forEach(function (r) {
      r.style.display = expanded ? 'none' : '';
    });
    headerEl.setAttribute('aria-expanded', expanded ? 'false' : 'true');
    if (!expanded) {
      setTimeout(function () {
        rows.forEach(initHostsInRow);
      }, 90);
    }
  }

  if (!window.__jugadasDayToggleBound) {
    window.__jugadasDayToggleBound = true;
    document.addEventListener('click', function (ev) {
      var header = ev.target.closest('.jugadas-day-header--collapsible');
      if (header) toggleDay(header);
    });
    document.addEventListener('keydown', function (ev) {
      if (ev.key !== 'Enter' && ev.key !== ' ') return;
      var header = ev.target.closest('.jugadas-day-header--collapsible');
      if (header) {
        ev.preventDefault();
        toggleDay(header);
      }
    });
  }

  function bootVisibleConsolidadoCharts() {
    requestAnimationFrame(function () {
      document.querySelectorAll('.jugadas-consolidado-chart-host').forEach(function (host) {
        var tr = host.closest('tr');
        if (tr && tr.style.display === 'none') return;
        window.__jugadasInitConsolidadoChartHost(host);
      });
    });
  }

  window.__jugadasBootConsolidadoCharts = bootVisibleConsolidadoCharts;
  window.__jugadasInitConsolidadoChartHost = function () {};

  if (typeof Highcharts === 'undefined') {
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', bootVisibleConsolidadoCharts);
    } else {
      bootVisibleConsolidadoCharts();
    }
    return;
  }

  function computeConsolidadoChartPixelHeight(host) {
    var layout = host.closest('.jugadas-consolidado-dia-layout');
    if (!layout) return null;

    var minHc = parseInt(host.getAttribute('data-min-chart-height'), 10);
    if (!(minHc >= 110)) minHc = 172;

    host.style.flex = '1 1 auto';
    host.style.minHeight = '0';
    host.style.overflow = 'hidden';

    void layout.offsetHeight;

    var h = host.clientHeight;
    if (!(h >= 64)) {
      host.style.minHeight = minHc + 'px';
      void layout.offsetHeight;
      h = host.clientHeight;
    }
    return Math.max(minHc, Math.floor(h));
  }

  function parseConsolidadoPayload(host) {
    var scr = host.querySelector('script.jugadas-consolidado-json');
    if (!scr || !scr.textContent) return null;
    try {
      var p = JSON.parse(scr.textContent);
      scr.parentNode.removeChild(scr);
      return p;
    } catch (_e) {
      return null;
    }
  }

  function consolidadoHcOptions(payload, chartPixelHeight) {
    var ch = chartPixelHeight || payload.height || 200;
    return {
      chart: {
        type: 'bar',
        backgroundColor: 'transparent',
        height: ch,
        spacing: [4, 8, 6, 8],
        style: {
          fontFamily:
            '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif'
        }
      },
      title: {
        text: payload.title,
        margin: 8,
        style: { fontSize: '13px', fontWeight: '700', color: '#111827' }
      },
      subtitle: {
        text: payload.subtitle,
        margin: 4,
        style: { fontSize: '11px', color: '#4b5563' }
      },
      credits: { enabled: false },
      exporting: { enabled: false },
      xAxis: {
        categories: payload.categories,
        labels: {
          style: { fontSize: '11px', color: '#374151' },
          step: 1,
          allowOverlap: true
        },
        lineWidth: 0,
        tickLength: 0
      },
      yAxis: {
        title: { text: payload.y_axis_title, style: { fontSize: '11px', color: '#6b7280' } },
        labels: { style: { fontSize: '10px', color: '#6b7280' } },
        gridLineColor: '#e5e7eb',
        plotLines: [{ value: 0, width: 1, color: '#9ca3af', zIndex: 4 }]
      },
      legend: { enabled: false },
      plotOptions: {
        bar: {
          borderWidth: 0,
          pointWidth: 13,
          pointPadding: 0.18,
          groupPadding: 0.14,
          minPointLength: 2,
          dataLabels: {
            enabled: payload.categories.length <= 14,
            formatter: function () {
              var v = this.y;
              if (v === null || v === undefined) return '';
              var s = Math.abs(v % 1) < 1e-9 ? String(Math.round(v)) : String(Number(v.toFixed(1)));
              return v > 0 ? '+' + s : s;
            },
            style: { fontSize: '10px', fontWeight: '700', textOutline: 'none', color: '#111827' }
          }
        }
      },
      series: [
        {
          name: payload.series_name,
          data: payload.profits.map(function (y) {
            return { y: y, color: y > 0 ? '#15803d' : y < 0 ? '#b91c1c' : '#6b7280' };
          })
        }
      ],
      tooltip: {
        shared: false,
        useHTML: true,
        formatter: function () {
          var i = this.point.index;
          if (payload.tooltips && payload.tooltips[i]) return payload.tooltips[i];
          return this.x + ': <b>' + this.y + '</b>';
        }
      }
    };
  }

  window.__jugadasInitConsolidadoChartHost = function (host) {
    if (!host) return;
    if (host.getAttribute('data-hc-mounted') === '1') {
      requestAnimationFrame(function () {
        var nh = computeConsolidadoChartPixelHeight(host);
        if (nh && host.__jugadasHcChart) {
          try {
            host.__jugadasHcChart.setSize(null, nh, false);
          } catch (_e) {}
        }
      });
      return;
    }
    var tr = host.closest('tr');
    if (tr && tr.style.display === 'none') return;

    var payload = parseConsolidadoPayload(host);
    if (!payload || !payload.categories || !payload.categories.length) return;

    host.__jugadasPayload = payload;
    host.setAttribute('data-hc-mounted', '1');

    function mount() {
      var nh = computeConsolidadoChartPixelHeight(host);
      if (!nh || nh < 48) nh = Math.min(Math.max(payload.height || 180, 110), 380);
      try {
        host.__jugadasHcChart = Highcharts.chart(host, consolidadoHcOptions(payload, nh));
      } catch (_e) {
        host.removeAttribute('data-hc-mounted');
        delete host.__jugadasPayload;
        return;
      }
      requestAnimationFrame(function () {
        var nh2 = computeConsolidadoChartPixelHeight(host);
        if (nh2 && host.__jugadasHcChart) {
          try {
            var cur = host.__jugadasHcChart.chartHeight;
            if (typeof cur !== 'number' || Math.abs(cur - nh2) > 2) {
              host.__jugadasHcChart.setSize(null, nh2, false);
            }
          } catch (_e2) {}
        }
      });
    }

    requestAnimationFrame(function () {
      requestAnimationFrame(mount);
    });
  };

  var __jugadasConsolidadoResizeT;
  window.addEventListener('resize', function () {
    clearTimeout(__jugadasConsolidadoResizeT);
    __jugadasConsolidadoResizeT = setTimeout(function () {
      document.querySelectorAll('.jugadas-consolidado-chart-host[data-hc-mounted="1"]').forEach(function (host) {
        if (!host.__jugadasHcChart) return;
        var nh = computeConsolidadoChartPixelHeight(host);
        if (nh) {
          try {
            host.__jugadasHcChart.setSize(null, nh, false);
          } catch (_e) {}
        }
      });
    }, 140);
  });

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', bootVisibleConsolidadoCharts);
  } else {
    bootVisibleConsolidadoCharts();
  }
})();
