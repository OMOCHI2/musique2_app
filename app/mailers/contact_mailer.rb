class ContactMailer < ApplicationMailer
  def send_mail(contact)
    @contact = contact
    mail(
      from: contact.email,
      to: "satsukisama.mochi@gmail.com",
      subject: "Webサイト「MUSIQUE」より問い合わせが届きました"
    )
  end
end
