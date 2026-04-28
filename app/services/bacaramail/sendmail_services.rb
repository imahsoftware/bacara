class Bacaramail::SendmailServices

  require 'sendgrid-ruby'
  include SendGrid

  def general(receiver, subject, template, fpath, fname, *args)
    mail = SendGrid::Mail.new
    sender = ENV.fetch('SENDGRID_FROM_EMAIL', 'notifier.bacara@gmail.com')
    mail.from = Email.new(email: sender)
    personalization = Personalization.new
    receiver = receiver.class == Array ? receiver : receiver.split(" ")
    receiver.each do |email|
      personalization.add_to(Email.new(email: email.to_s, name: email.to_s))
    end
    mail.add_personalization(personalization)
    mail.subject = subject
    mail.add_content(Content.new(
      type: 'text/html',
      value: ApplicationController.render(
        template: template,
        layout: nil,
        locals: {
          object0: args[0], object1: args[1], object2: args[2]
        }
      )))

    fileadd = fpath.to_s + fname.to_s
    if fileadd.present?
      attachment = SendGrid::Attachment.new
      attachment.content = Base64.strict_encode64(File.open(fileadd, 'rb').read)
      attachment.type = 'application/pdf'
      attachment.filename = fname
      attachment.disposition = 'attachment'
      attachment.content_id = 'Reports Sheet'
      mail.add_attachment(attachment)
    end
    api_key = ENV['SENDGRID_API_KEY']
    if api_key.blank?
      Rails.logger.error("[Bacaramail] SENDGRID_API_KEY no está definido — el correo NO se envió a #{receiver.inspect}")
      return nil
    end

    sg = SendGrid::API.new(api_key: api_key)
    response = sg.client.mail._('send').post(request_body: mail.to_json)

    if response.status_code.to_i == 202
      Rails.logger.info("[Bacaramail] ✅ SendGrid aceptó el correo para #{receiver.inspect} (status 202)")
    else
      Rails.logger.error("[Bacaramail] ❌ SendGrid rechazó el correo para #{receiver.inspect} — status=#{response.status_code} body=#{response.body}")
    end

    response
  end
end