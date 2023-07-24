class ContactMailer < ApplicationMailer
  def send_mail(contact)
    @contact = contact
    mail(
      from: contact.email,
      to: ENV['ADMIN_EMAIL'],
      subject: "Webサイト「MUSIQUE」より問い合わせが届きました"
    )
  end
end
