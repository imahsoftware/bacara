namespace :bacara do

  # --------------------------------------------------------------------------------------------------------------
  # Trasnmision de obligaciones
  # --------------------------------------------------------------------------------------------------------------

  task checkusers: :environment do
    User.checkuser
  end

  task download: :environment do
    #Solo para los errores
    nmPortafolio = ENV['p']
    nmIsAdmin = ENV['a']
    nmConse = ENV['c']
    vcProceso = ENV['r']
    Proceso.download(nmPortafolio, nmIsAdmin, nmConse, vcProceso)
  end

  # rake coquetin:enviodian a=1 b=13 c=24 d=16
  task enviodian: :environment do
    nmPortafolio = ENV['a']
    nmPeriodo = ENV['b']
    contrato = ENV['c']
    contratogrupo = ENV['d']
    WsController.enviar_nomina(nmPortafolio, nmPeriodo, contrato, contratogrupo)
  end


  task enviocorreo: :environment do
    idprocesamiento = Time.now.strftime("%Y%m%d%H%M%S").to_s
    if Ejecucion.where("estado = 'PENDIENTE' and tipo in ('ENVIO CORREO','ENVIO SMS') and idprocesamiento is null and created_at <= now()").exists?
      Ejecucion.where(["estado = 'PENDIENTE' and tipo in ('ENVIO CORREO','ENVIO SMS') and idprocesamiento is null and created_at <= now()"]).update_all(idprocesamiento: idprocesamiento)
      Ejecucion.where("estado = 'PENDIENTE' and tipo in ('ENVIO CORREO','ENVIO SMS') and idprocesamiento = '#{idprocesamiento}' and created_at <= now()").each do |e|
        Ejecucion.where(["id  = #{e.id}"]).update_all(estado: 'EN EJECUCION', inicioejecucion: Time.now)
        begin
          execute = e.controlador_metodo.to_s
          eval(execute)
          Ejecucion.where(["id  = #{e.id}"]).update_all(estado: 'EXITOSO', finejecucion: Time.now)
        rescue Exception => ex
          Ejecucion.where(["id  = #{e.id}"]).update_all(estado: 'ERROR', observacion: ex.message[0..995].to_s, finejecucion: Time.now)
        end
      end
    end
    #if ['08','10','12','14','16','18','20','22'].include?(Time.now.strftime("%H").to_s)
    #  ActiveRecord::Base.connection.execute("CALL prc_personasformvalida();")
    #end
  end

end