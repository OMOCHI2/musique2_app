# Preview all emails at http://localhost:3000/rails/mailers/contact_mailer
class ContactMailerPreview < ActionMailer::Preview

  def send_mail
    contact = Contact.new(name: "Contact Tester", email: "contacttest@example.com", content: "お問い合わせのテストです")
    ContactMailer.send_mail(contact).deliver_now
  end
end
