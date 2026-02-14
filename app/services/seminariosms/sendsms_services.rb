class Bacarasms::SendsmsServices

  #Bacarasms::SendsmsServices.new.send_sms_procesos('','Prueba de envio')
  def send_sms_procesos(idMovil, mensajeDescripcion)
    WsController.smscolombiared(idMovil.to_s,mensajeDescripcion.to_s)
  end
end