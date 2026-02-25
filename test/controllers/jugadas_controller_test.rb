require 'test_helper'

class JugadasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @jugada = jugadas(:one)
  end

  test "should get index" do
    get jugadas_url
    assert_response :success
  end

  test "should get new" do
    get new_jugada_url
    assert_response :success
  end

  test "should create jugada" do
    assert_difference('Jugada.count') do
      post jugadas_url, params: { jugada: { estado: @jugada.estado, fecha: @jugada.fecha, jugador: @jugada.jugador } }
    end

    assert_redirected_to jugada_url(Jugada.last)
  end

  test "should show jugada" do
    get jugada_url(@jugada)
    assert_response :success
  end

  test "should get edit" do
    get edit_jugada_url(@jugada)
    assert_response :success
  end

  test "should update jugada" do
    patch jugada_url(@jugada), params: { jugada: { estado: @jugada.estado, fecha: @jugada.fecha, jugador: @jugada.jugador } }
    assert_redirected_to jugada_url(@jugada)
  end

  test "should destroy jugada" do
    assert_difference('Jugada.count', -1) do
      delete jugada_url(@jugada)
    end

    assert_redirected_to jugadas_url
  end
end
