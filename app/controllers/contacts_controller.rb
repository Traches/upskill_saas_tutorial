class ContactsController < ApplicationController
  
  #GET request to /contact-us
  # Show new contact form
  def new
    @contact = Contact.new
  end
  
  # POST request to /contacts
  def create
    # Mass assignment of form fields to new contact object
    @contact = Contact.new(contact_params)
    # Save to database
    if @contact.save
      # Store form fields via parameters to local variables
      name = params[:contact][:name]
      email = params[:contact][:email]
      body = params[:contact][:comments]
      # Plug variables into ContactMailer, send email. 
      ContactMailer.contact_email(name, email, body).deliver
      #Store success message in flash has, redirect to new action. 
      flash[:success] = "Message Sent."
      redirect_to new_contact_path
    else
      # If input doesn't pass input validation, set error in flash has and 
      # redirect. 
      flash[:danger] = @contact.errors.full_messages.join(", ")
      redirect_to new_contact_path
    end
  end
  
  private
    # To collect data from form, we need to use strong parameters & whitelist
    # the form fields. 
    def contact_params
      params.require(:contact).permit(:name, :email, :comments)
    end
    
end