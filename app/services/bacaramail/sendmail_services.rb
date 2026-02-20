class Bacaramail::SendmailServices

  require 'sendgrid-ruby'
  include SendGrid

  def general(receiver, subject, template, fpath, fname, *args)
    mail = SendGrid::Mail.new
    mail.from = Email.new(email: 'notifier.bacara@gmail.com')
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
    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    return response
  end
end