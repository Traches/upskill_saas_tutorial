class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  belongs_to :plan     


  attr_accessor :stripe_card_token
  # IF Pro user passes form validations, call stripe and tell them to set up 
  # a card token. We then use this card token to set up a stripe subscription, 
  # saving a customer token to our database. 
  
  def save_with_subscription
    if valid?
      customer = Stripe::Customer.create(description: email, plan: plan_id, card: stripe_card_token)
      # customer = Stripe::Customer.create(
      #   :description => email,
      #   :plan => plan_id,
      #   :source => stripe_card_token
      #   )
      self.stripe_customer_token = customer.id
      save!
    end
  end
end
