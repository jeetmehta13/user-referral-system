class HomeController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @previous_invitations = previous_invitations
    @dashboard_type = current_user.user_type
  end

  def previous_invitations
    Referral.where(:referrer_id => current_user.id);
  end

  def send_invitation
    email = params[:referral][:email]

    if User.exists?(:email => email) 
      redirect_to root_path, notice: "User already signed up!"
    else 
      referral_key = SecureRandom.hex(8)
  
      signup_url = "http://localhost:3000/users/sign_up?referral_key=#{referral_key}"
  
      UserMailer.invitation_email(email, signup_url).deliver_now
  
      Referral.create(:referrer_id => current_user.id, :referred_email => email, :sent_count => 1, :referral_key => referral_key)
      
      redirect_to root_path, notice: "Invitation sent!"
    end
  end
end