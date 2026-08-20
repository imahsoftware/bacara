//= require jquery
//= require bootstrap-sprockets
// DISABLED: //= require jquery.remotipart
//= require jquery_ujs
//= require jquery-ui/widgets/datepicker
//= require jquery-ui/widgets/autocomplete
//= require autocomplete-rails
//= require autonumeric
//= require moment
//= require moment/es
//= require bootstrap-datetimepicker
//= require pickers
//= require plugins/iCheck/icheck.min
//= require highcharts
//= require simple_form_autocomplete
//= require highcharts/highcharts-more
//= require highcharts/highcharts-3d.js
//= require highcharts/modules/annotations
//= require highcharts/modules/data
//= require highcharts/modules/drilldown
//= require highcharts/modules/exporting
//= require highcharts/modules/funnel
//= require highcharts/modules/heatmap
//= require highcharts/modules/no-data-to-display
//= require highcharts/modules/offline-exporting
//= require Chart.min
//= require dist/js/app.min
// DISABLED: //= require bootstrap-wysihtml5
//= require underscore
//= require gmaps/google
// DISABLED: //= require best_in_place
// DISABLED: //= require signature-pad
//= require_tree .
//= require notifications

$(function () {
    $(".select2").select2();
    $('.wysihtml5').wysihtml5();
    $('[data-toggle="popover"]').popover();
});

$(document).ready(function () {
    jQuery(".best_in_place").best_in_place();
});

$("a[data-popover-title]").each(function (e, elem) {
    var _this = this;
    $(this).popover({
        title: $(this).data('popover-title'),
        content: $(this).data('popover-content'),
        trigger: "manual",
        animation: false
    }).on("mouseenter", function () {
        $(_this).popover("show");
    }).parent().on("mouseleave", function () {
        $(_this).popover("hide");
    })
});

$(function () {
    $('.datepicker').datepicker({
        dayNamesMin: ["Dom", "Lun", "Mar", "Mie", "Jue", "Vie", "Sáb"],
        monthNamesShort: ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"],
        dateFormat: "yy-mm-dd",
        yearRange: '1950:2027',
        changeMonth: true,
        changeYear: true,
    });

    $("#idforminit").submit(function () {
        $("#user_username").val();
        $("#user_password").val();
    });
});

function SINO(cual) {
    var elElemento = document.getElementById(cual);
    if (elElemento.style.display == 'block') {
        elElemento.style.display = 'none';
    } else {
        elElemento.style.display = 'block';
    }
}

function soloNumeros(e) {
    var key = window.Event ? e.which : e.keyCode
    return (key >= 48 && key <= 57)
}

function mostrar(selc) {
    if (selc.value == "per") {
        document.getElementById('persona').style.display = 'block'
        document.getElementById('nuevo').style.display = 'none'
    } else {
        document.getElementById('persona').style.display = 'none'
        document.getElementById('nuevo').style.display = 'block'
    }
}

function mostraralianza(selc) {
    if (selc.value == "sia") {
        document.getElementById('alianzasi').style.display = 'block'
    } else {
        document.getElementById('alianzasi').style.display = 'none'
    }
}

function mostrarconvenio(selc) {
    if (selc.value == "sic") {
        document.getElementById('conveniosi').style.display = 'block'
    } else {
        document.getElementById('conveniosi').style.display = 'none'
    }
}

function countChar(val) {
    var len = val.value.length;
    if (len >= 4000) {
        val.value = val.value.substring(0, 4000);
    } else {
        $('#charNum').text(4000 - len);
    }
};

function countChar2(val) {
    var len = val.value.length;
    if (len >= 500) {
        val.value = val.value.substring(0, 500);
    } else {
        $('#charNum').text(500 - len);
    }
};

function countChar3(val) {
    var len = val.value.length;
    if (len >= 500) {
        val.value = val.value.substring(0, 255);
    } else {
        $('#charNum').text(255 - len);
    }
};

function countChar4(val) {
    var len = val.value.length;
    if (len >= 4000) {
        val.value = val.value.substring(0, 4000);
    } else {
        $('#charNum').text(4000 - len);
    }
};

function countChar5(val) {
    var len = val.value.length;
    if (len >= 255) {
        val.value = val.value.substring(0, 255);
    } else {
        $('#charNum').text(255 - len);
    }
};

$(function () {
    return $('.select2Ciudad').select2({
        minimumInputLength: 3,
        maximumInputLength: 20,
        placeholder: "[ Seleccionar Ciudad... ]",
        ajax: {
            url: '/personas/search.json',
            dataType: 'json',
            delay: 250,
            data: function (params) {
                return {
                    q: params.term,
                    page: params.page
                };
            },
            processResults: function (data) {
                return {
                    results: $.map(data, function (item) {
                        return {
                            text: item.name,
                            id: item.id
                        };
                    })
                };
            }
        }
    });
});

$(function () {
    return $('.select2ContratoIndex').select2({
        minimumInputLength: 3,
        maximumInputLength: 20,
        placeholder: "[ Seleccionar Contrato... ]",
        ajax: {
            url: '/contratos/searchall.json',
            dataType: 'json',
            delay: 250,
            data: function (params) {
                return {
                    q: params.term,
                    page: params.page
                };
            },
            processResults: function (data) {
                return {
                    results: $.map(data, function (item) {
                        return {
                            text: item.name,
                            id: item.id
                        };
                    })
                };
            }
        }
    });
});

$(function () {
    return $('.select2ContratoIndexMasive').select2({
        minimumInputLength: 3,
        maximumInputLength: 20,
        placeholder: "[ Seleccionar Contrato... ]",
        ajax: {
            url: '/contratos/searchall.json',
            dataType: 'json',
            delay: 250,
            data: function (params) {
                return {
                    q: params.term,
                    page: params.page
                };
            },
            processResults: function (data) {
                return {
                    results: $.map(data, function (item) {
                        return {
                            text: item.name,
                            id: item.id
                        };
                    })
                };
            }
        }
    });
});

$(function () {
    return $('.select2UserIndexMasive').select2({
        minimumInputLength: 3,
        maximumInputLength: 20,
        placeholder: "[ Seleccionar Usuario... ]",
        ajax: {
            url: '/users/searchall.json',
            dataType: 'json',
            delay: 250,
            data: function (params) {
                return {
                    q: params.term,
                    page: params.page
                };
            },
            processResults: function (data) {
                return {
                    results: $.map(data, function (item) {
                        return {
                            text: item.name,
                            id: item.id
                        };
                    })
                };
            }
        }
    });
});


$(function () {
    return $('.select2ContratoIndexQUINCENAL').select2({
        minimumInputLength: 3,
        maximumInputLength: 20,
        placeholder: "[ Seleccionar Contrato... ]",
        ajax: {
            url: '/contratos/search.json',
            dataType: 'json',
            delay: 250,
            data: function (params) {
                return {
                    q: params.term,
                    page: params.page
                };
            },
            processResults: function (data) {
                return {
                    results: $.map(data, function (item) {
                        return {
                            text: item.name,
                            id: item.id
                        };
                    })
                };
            }
        }
    });
});


$(function () {
    return $('.select2ContratoIndexMENSUAL').select2({
        minimumInputLength: 3,
        maximumInputLength: 20,
        placeholder: "[ Seleccionar Contrato... ]",
        ajax: {
            url: '/contratos/searchm.json',
            dataType: 'json',
            delay: 250,
            data: function (params) {
                return {
                    q: params.term,
                    page: params.page
                };
            },
            processResults: function (data) {
                return {
                    results: $.map(data, function (item) {
                        return {
                            text: item.name,
                            id: item.id
                        };
                    })
                };
            }
        }
    });
});


$(document).ready(function () {
    $("#dttb").dataTable(
        {
            "language": {
                "sSearch": "Buscar",
                "lengthMenu": "Mostrar _MENU_ registros por página",
                "zeroRecords": "No se encontró nada - lo siento",
                "info": "Mostrando página _PAGE_ de _PAGES_",
                "infoEmpty": "No hay registros disponibles",
                "infoFiltered": "(filtrado de _MAX_ total registros)",
                "paginate": {
                    "previous": "Anterior",
                    "next": "Siguiente",
                    "first": "Inicio",
                    "last": "Fin"
                }
            },
            pageLength: 0,
            lengthMenu: [10, 20, 30, 40, 50, 100, 200, 500]

        }
    );
});

$(document).ready(function () {
    $("#dttbContratacion").dataTable(
        {
            "language": {
                "sSearch": "Buscar",
                "lengthMenu": "Mostrar _MENU_ registros por página",
                "zeroRecords": "No se encontró nada - lo siento",
                "info": "Mostrando página _PAGE_ de _PAGES_",
                "infoEmpty": "No hay registros disponibles",
                "infoFiltered": "(filtrado de _MAX_ total registros)",
                "paginate": {
                    "previous": "Anterior",
                    "next": "Siguiente",
                    "first": "Inicio",
                    "last": "Fin"
                }
            },
            pageLength: 0,
            lengthMenu: [10, 20, 30, 40, 50, 100, 200, 500]

        }
    );
});

$(document).ready(function () {
    $("#dttbPrefactura").dataTable(
        {
            "language": {
                "sSearch": "Buscar",
                "lengthMenu": "Mostrar _MENU_ registros por página",
                "zeroRecords": "No se encontró nada - lo siento",
                "info": "Mostrando página _PAGE_ de _PAGES_",
                "infoEmpty": "No hay registros disponibles",
                "infoFiltered": "(filtrado de _MAX_ total registros)",
                "paginate": {
                    "previous": "Anterior",
                    "next": "Siguiente",
                    "first": "Inicio",
                    "last": "Fin"
                }
            },
            pageLength: 0,
            lengthMenu: [10, 20, 30, 40, 50, 100, 200, 500]
        }
    );
});

$(document).ready(function () {
    $("#dtCarnet").dataTable(
        {
            "language": {
                "sSearch": "Buscar",
                "lengthMenu": "Mostrar _MENU_ registros por página",
                "zeroRecords": "No se encontró nada - lo siento",
                "info": "Mostrando página _PAGE_ de _PAGES_",
                "infoEmpty": "No hay registros disponibles",
                "infoFiltered": "(filtrado de _MAX_ total registros)",
                "paginate": {
                    "previous": "Anterior",
                    "next": "Siguiente",
                    "first": "Inicio",
                    "last": "Fin"
                }
            },
            pageLength: 0,
            lengthMenu: [10, 20, 30, 40, 50, 100, 200, 500]
        }
    );
});

/*
$(document).ready(function () {
    function resizeCanvas(canvas) {
        var ratio = Math.max(window.devicePixelRatio || 1, 1);
        canvas.width = canvas.offsetWidth * ratio;
        canvas.height = canvas.offsetHeight * ratio;
        canvas.getContext("2d").scale(ratio, ratio);
    }
});
*/

function copiarAlPortapapeles(id_elemento) {
    var aux = document.createElement("input");
    aux.setAttribute("value", document.getElementById(id_elemento).innerHTML);
    document.body.appendChild(aux);
    aux.select();
    document.execCommand("copy");
    document.body.removeChild(aux);
}

$(document).ready(function () {
    var canvas = document.querySelector("canvas");
    if (canvas) {
        canvas.height = canvas.offsetHeight;
        canvas.width = canvas.offsetWidth;
        window.onresize = resizeCanvas(canvas);
        resizeCanvas(canvas);
        signature_pad = new SignaturePad(canvas);
        $('.signature_pad_clear').click(function () {
            signature_pad.clear()
        });
        $('.signature_pad_save').click(function (event) {
            if (signature_pad.isEmpty()) {
                alert('Debes firmar para aceptar los Términos y Condiciones');
                event.preventDefault();
            } else {
                $('.signature_pad_input').val(signature_pad.toDataURL('image/png'));
            }
        });
    }
});

/// Convierte texto en mayuscula
$('.uppercaseInput').keyup(function () {
    $(this).val($(this).val().toUpperCase());
});


$(function () {
    return $('.select2EmpleadoContrato').select2({
        minimumInputLength: 3,
        maximumInputLength: 20,
        placeholder: "[ Seleccionar Empleado... ]",
        ajax: {
            url: '/contratosperfechas/search_persona.json',
            dataType: 'json',
            delay: 50,
            data: function (params) {
                return {
                    q: params.term,
                    page: params.page
                };
            },
            processResults: function (data) {
                return {
                    results: $.map(data, function (item) {
                        return {
                            text: item.name,
                            id: item.id
                        };
                    })
                };
            }
        }
    });
});

/*
var signaturePad = new SignaturePad($("#myCanvas").get(0));

$("#showAsImage").click(function() {
    // Get DataURL
    var dataUrl = signaturePad.toDataURL("image/png");

    // Create image
    var image = new Image;
    image.src = dataUrl;
    // Add image element to wrapper
    $("#imageWrapper").html(image);
});
*/


$(document).ready(function () {
    $('.select2EmpleadoId').select2({
        minimumInputLength: 3,
        maximumInputLength: 20,
        placeholder: "[ Seleccionar Ciudad... ]",
        ajax: {
            url: '/contratosperfechas/search_persona.json',
            dataType: 'json',
            delay: 250,
            data: function (params) {
                return {
                    q: params.term,
                    page: params.page
                };
            },
            processResults: function (data) {
                return {
                    results: $.map(data, function (item) {
                        return {
                            text: item.name,
                            id: item.id
                        };
                    })
                };
            }
        }
    });
});


/// buscador paera nav - ul - li
$(document).ready(function () {
    $("#filter").keyup(function () {

        // Retrieve the input field text and reset the count to zero
        var filter = $(this).val(), count = 0;

        // Loop through the comment list
        $("nav ul li.filtro-search").each(function () {

            // If the list item does not contain the text phrase fade it out
            if ($(this).text().search(new RegExp(filter, "i")) < 0) {
                $(this).fadeOut();

                // Show the list item if the phrase matches and increase the count by 1
            } else {
                $(this).show();
                count++;
            }
        });

        // Update the count
        var numberItems = count;
        $("#filter-count").text("Number of Filter = " + count);
    });
});


$(document).ready(function () {
    $("#filter2").keyup(function () {

        // Retrieve the input field text and reset the count to zero
        var filter = $(this).val(), count = 0;

        // Loop through the comment list
        $("nav ul li.filtro-search2").each(function () {

            // If the list item does not contain the text phrase fade it out
            if ($(this).text().search(new RegExp(filter, "i")) < 0) {
                $(this).fadeOut();

                // Show the list item if the phrase matches and increase the count by 1
            } else {
                $(this).show();
                count++;
            }
        });

        // Update the count
        var numberItems2 = count;
        $("#filter-count2").text("Number of Filter = " + count);
    });
});




// PROCESO PARA ENVIO CON AJAX PARA LOS MOVIMIENTOS


(function () {
    'use strict';

    // Evitar doble binding si por alguna razón el script se carga dos veces
    if (window._jdBound) return;
    window._jdBound = true;

    function csrfToken() { return $('meta[name="csrf-token"]').attr('content'); }
    function showSpinner() { $('#jd-spinner').fadeIn(150); }
    function hideSpinner() { $('#jd-spinner').fadeOut(200); }
    function setLoading(btn, on) { on ? $(btn).addClass('jd-loading') : $(btn).removeClass('jd-loading'); }

    function addRipple(btn, e) {
        var off = $(btn).offset();
        var size = Math.max($(btn).outerWidth(), $(btn).outerHeight());
        var $r = $('<span class="jd-ripple"></span>').css({
            width: size, height: size,
            left: e.pageX - off.left - size / 2,
            top:  e.pageY - off.top  - size / 2
        });
        $(btn).append($r);
        setTimeout(function () { $r.remove(); }, 600);
    }

    // ── Clic en P o B ────────────────────────────────────────────
    // jdCreateInFlight evita que clics rápidos/alternados en P y B disparen
    // varias peticiones POST /jugadasdetalles en paralelo: antes solo el botón
    // clicado quedaba con pointer-events:none (jd-loading), así que darle a P y
    // luego, sin esperar, a B, sí lograba mandar dos peticiones concurrentes
    // para la misma jugada, causando datos/estados inconsistentes en pantalla.
    var jdCreateInFlight = false;

    $(document).off('click.jd', '#btn-player, #btn-banker')
        .on ('click.jd', '#btn-player, #btn-banker', function (e) {
            if (jdCreateInFlight) return;

            var $btn     = $(this);
            var $circles = $('#btn-player, #btn-banker');
            var tipo     = $btn.data('tipo');
            var jugadaId = $btn.data('jugada-id');
            var baseBet  = $('#jd-base-bet').val() || 10;

            addRipple($btn, e);
            jdCreateInFlight = true;
            $circles.addClass('jd-loading');
            showSpinner();

            $.ajax({
                url:      '/jugadasdetalles',
                type:     'POST',
                dataType: 'script',
                headers:  { 'X-CSRF-Token': csrfToken() },
                data:     { jugada_id: jugadaId, tipo: tipo, base_bet: baseBet },
                error: function (xhr) {
                    alert('Error al registrar movimiento: ' + (xhr.responseText || 'desconocido'));
                },
                complete: function () {
                    jdCreateInFlight = false;
                    $circles.removeClass('jd-loading');
                    hideSpinner();
                }
            });
        });

    // ── Botón Undo ────────────────────────────────────────────────
    $(document).off('click.jd', '#btn-undo')
        .on ('click.jd', '#btn-undo', function () {
            var $btn     = $(this);
            var jugadaId = $btn.data('jugada-id');

            // Verificación client-side del límite de undos para no-admins
            var undoMax   = $btn.data('undo-max');
            var undoCount = parseInt($btn.attr('data-undo-count') || '0', 10);
            if (undoMax !== '' && undoMax !== undefined && undoMax !== null) {
                var maxInt = parseInt(undoMax, 10);
                if (!isNaN(maxInt) && undoCount >= maxInt) {
                    alert('Has alcanzado el límite de ' + maxInt + ' undo(s) permitidos.');
                    return;
                }
            }

            $btn.prop('disabled', true).text($btn.data('label-loading') || 'Undoing...');
            showSpinner();

            $.ajax({
                url:      '/jugadasdetalles/undo',
                type:     'POST',
                dataType: 'script',
                headers:  { 'X-CSRF-Token': csrfToken() },
                data:     { jugada_id: jugadaId },
                error:    function () { alert('Error al deshacer.'); },
                complete: function () {
                    var newCount = parseInt($btn.attr('data-undo-count') || '0', 10);
                    var max      = $btn.data('undo-max');
                    if (max !== '' && max !== undefined && max !== null && !isNaN(parseInt(max, 10)) && newCount >= parseInt(max, 10)) {
                        $btn.prop('disabled', true).addClass('disabled');
                    } else {
                        $btn.prop('disabled', false).text($btn.data('label-default') || 'Undo Last Hand');
                    }
                    hideSpinner();
                }
            });
        });

    // ── Botón Reset ───────────────────────────────────────────────
    $(document).off('click.jd', '#btn-reset')
        .on ('click.jd', '#btn-reset', function () {
            var $btn     = $(this);
            var jugadaId = $btn.data('jugada-id');

            $btn.prop('disabled', true).text($btn.data('label-loading') || 'Clearing...');
            showSpinner();

            $.ajax({
                url:      '/jugadasdetalles/reset',
                type:     'POST',
                dataType: 'script',
                headers:  { 'X-CSRF-Token': csrfToken() },
                data:     { jugada_id: jugadaId },
                error:    function () { alert('Error al resetear.'); },
                complete: function () {
                    $btn.prop('disabled', false).text($btn.data('label-default') || 'Clear Session');
                    hideSpinner();
                }
            });
        });

    // ── Botón Finish (cerrar jugada CERRADA en BD, sin recargar) ──
    $(document).off('click.jd', '#btn-finish')
        .on ('click.jd', '#btn-finish', function () {
            var $btn     = $(this);
            var jugadaId = $btn.data('jugada-id');

            $btn.prop('disabled', true).text($btn.data('label-loading') || 'Finishing...');
            showSpinner();

            $.ajax({
                url:      '/jugadasdetalles/finish',
                type:     'POST',
                dataType: 'script',
                headers:  { 'X-CSRF-Token': csrfToken() },
                data:     { jugada_id: jugadaId },
                error:    function () { alert('Error al finalizar la sesión.'); },
                complete: function () {
                    if ($('#btn-finish').is(':visible')) {
                        $btn.prop('disabled', false).text($btn.data('label-default') || 'Finish');
                    }
                    hideSpinner();
                }
            });
        });

})();