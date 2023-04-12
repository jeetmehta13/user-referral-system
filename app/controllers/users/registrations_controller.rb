# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :verify_authenticity_token, only: [:create]
  before_action :configure_sign_up_params, only: [:create]
  before_action :check_referral_param, only: [:new]
  after_action :mark_referral_used, only: [:create]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    if params['user'].blank?
      error = { error: 'Missing user data'}
      return render :json => error
    end
    @referral_key = params['referral_key']
    if !check_referral_exists
      error = { error: 'Missing the referral_key query param'}
      return render :json => error
    end
    if params['user']['email'].blank?
      error = { error: 'Missing email in data'}
      return render :json => error
    end
    @referred_email = params['user']['email']
    @referral = Referral.find_by(referral_key: @referral_key, referred_email: @referred_email)
    if @referral.nil?
      error = { error: 'The email is not linked to the referral key, or the referral key is incorrect'}
      return render :json => error
    end
    super
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def check_referral_exists
    return !@referral_key.blank?
  end

  def check_referral_validity
    @referral = Referral.find_by(referral_key: @referral_key, referral_used: false)
    !@referral.nil?
  end

  def check_referral_param
    @referral_key_present = true
    @referral_key_valid = true
    @referred_email = ""
    
    @referral_key = params[:referral_key]
    
    if !check_referral_exists
      @referral_key_present = false
    else
      if check_referral_validity
        @referred_email = @referral.referred_email    
      else
        @referral_key_valid = false
      end
    end
  end

  def mark_referral_used
    if !@referral_key.blank? and !@referred_email.blank?
      user = User.find_by(email: @referred_email)
      if !user.nil? and !@referral.nil?
        @referral.update(referral_used: true)
        referrer_user = User.find_by(id: @referral.referrer_id)
        user.update(referred_by: referrer_user.email)
      end
    end 
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :referral_key])
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    root_path
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
