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
    begin
      email = params[:referral][:email]

      if User.exists?(email: email) 
        redirect_to root_path, notice: { message: "User already signed up!", type: "danger" }
      else 
        notice = { message: "Invitation sent!", type: "success" }
        referral_key = SecureRandom.hex(8)
        
        referred_previously = Referral.find_by(referrer_id: current_user.id, referred_email: email);
        if referred_previously.nil?
          create_and_invite(email, referral_key)
          Referral.create(referrer_id: current_user.id, referred_email: email, sent_count: 1, referral_key: referral_key)
        else
          if referred_previously.sent_count >= 5
            notice = { message: "Maximum number of invitations sent!", type: "danger" }
          else
            create_and_invite(email, referral_key)
            sent_count = referred_previously.sent_count + 1
            referred_previously.update(sent_count: sent_count, referral_key: referral_key) 
          end
        end
        
        redirect_to root_path, notice: notice
      end
    rescue => exception
      redirect_to root_path, notice: { message: "Internal error occurred, please try again. Contact us if the error persists.", type: "danger" }
    end
  end

  private

    def create_and_invite(email, referral_key)
      signup_url = ENV['BASE_URL'] + new_user_registration_path(referral_key: referral_key)
      UserMailer.invitation_email(email, signup_url).deliver_now
    end
end