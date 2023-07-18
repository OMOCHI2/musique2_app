class ContactsController < ApplicationController

  def index
    @contact = Contact.new
  end

  def confirm
    @contact = Contact.new(contact_params)
    if @contact.valid?
      render "confirm", status: :unprocessable_entity
    else
      render "index", status: :unprocessable_entity
    end
  end

  def done
    @contact = Contact.new(contact_params)
    if params[:back]
      render "index", status: :unprocessable_entity
    else
      ContactMailer.send_mail(@contact).deliver_now
      render "done", status: :unprocessable_entity
    end
  end

  private
      def contact_params
        params.require(:contact).permit(:name, :email, :content)
      end
end
