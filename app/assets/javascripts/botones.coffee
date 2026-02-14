jQuery ->
  $("body").on "click", "#cancelar-form", ->
    $('#modulos-form').slideUp(350);
    $("#link_new_modulo").removeClass("disabled");

  $("body").on "click", "#cancelar-form-ob", ->
    $('#objetos-form').slideUp(350);
    $("#link_new_objeto").removeClass("disabled");


  $("body").on "click", "#cancelar-form-codeudores", ->
    $('#personascodeudor-form').slideUp(350);
    $("#link_new_personascodeudor").removeClass("disabled");

  $("body").on "click", "#cancelar-form-obligaciones", ->
    $('#personasobligacion-form').slideUp(350);
    $("#link_new_personasobligacion").removeClass("disabled");
