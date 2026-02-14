class PdfController < ApplicationController

  require 'zip'

  def descargar_informe_combinado
    mes = params[:mes]
    contratoId = params[:contrato_id]
    isadmin = is_admin

    fname = "INFORME_COMPLETO_#{mes.gsub('-','_')}_" + contratoId + '.zip'
    zipfile_folder = Rails.root.join("public", "combinar", fname)
    File.delete(zipfile_folder) if File.exist?(zipfile_folder)

    # Generar los PDFs
    VisitasController.informegeneral_contrato_combine(mes, contratoId, isadmin)
    ContratoscapapersonasController.capacitacion_pdf_contrato_combine(mes, contratoId, isadmin)
    ContratosenteppsController.informegeneral_contrato_combine(mes, contratoId, isadmin)

    documento1 = Rails.root.join("public", "combinar", "Capacitacion_#{contratoId}.pdf")
    documento2 = Rails.root.join("public", "combinar", "InformeMensualEpps_#{contratoId}.pdf")
    documento3 = Rails.root.join("public", "combinar", "InformeMensualContrato_#{contratoId}.pdf")

    # Crear archivo ZIP
    Zip::File.open(zipfile_folder, Zip::File::CREATE) do |zipfile|
      zipfile.add("Capacitacion_#{contratoId}.pdf", documento1) if File.exist?(documento1) && !zipfile.find_entry("Capacitacion_#{contratoId}.pdf")
      zipfile.add("InformeMensualEpps_#{contratoId}.pdf", documento2) if File.exist?(documento2) && !zipfile.find_entry("InformeMensualEpps_#{contratoId}.pdf")
      zipfile.add("InformeMensualContrato_#{contratoId}.pdf", documento3) if File.exist?(documento3) && !zipfile.find_entry("InformeMensualContrato_#{contratoId}.pdf")
    end

    # Enviar archivo ZIP
    send_file zipfile_folder, type: 'application/zip', filename: fname

    # Eliminar archivos temporales
    File.delete(documento1) if File.exist?(documento1)
    File.delete(documento2) if File.exist?(documento2)
    File.delete(documento3) if File.exist?(documento3)

  end



  def descargar_informe_combinado2
    mes = params[:mes]
    contratoId = params[:contrato_id]
    isadmin = is_admin

    # Generar los PDFs
    # VisitasController.informegeneral_contrato_combine(mes, contratoId, isadmin)
    ContratoscapapersonasController.capacitacion_pdf_contrato_combine(mes, contratoId, isadmin)
    ContratosenteppsController.informegeneral_contrato_combine(mes, contratoId, isadmin)

    pdf_files = [
      Rails.root.join("public", "combinar", "Capacitacion_#{contratoId}.pdf"),
      Rails.root.join("public", "combinar", "InformeMensualEpps_#{contratoId}.pdf")
    ]

    combined_pdf = CombinePDF.new

    pdf_files.each do |file|
      combined_pdf << CombinePDF.load(file) if File.exist?(file)
    end

    # Enviar el PDF combinado como respuesta
    send_data combined_pdf.to_pdf, filename: "Informe_completoContato_#{contratoId}.pdf", type: 'application/pdf'

    # Eliminar los archivos temporales
    pdf_files.each do |file|
      File.delete(file) if File.exist?(file)
    end
  end

  def combine_pdfs
    pdf_files = []
    pdf1 = "#{::Rails.root}/public/archivos/pdf/pdf1.pdf"
    pdf2 = "#{::Rails.root}/public/archivos/pdf/pdf2.pdf"

    pdf_files << pdf1
    pdf_files << pdf2

    combined_pdf = CombinePDF.new

    pdf_files.each do |file|
      combined_pdf << CombinePDF.load(file)
    end

    send_data combined_pdf.to_pdf, filename: "pdf_combinado.pdf", type: 'application/pdf'
  end
end