class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    log_in(request.env['omniauth.auth'])
  end

  def facebook
    log_in(request.env['omniauth.auth'])
  end

  def set_email
    password = Devise.friendly_token[0, 20]
    user = User.new(email: params[:email], password: password, password_confirmation: password)
    if user.save
      user.authorizations.create(provider: session[:provider], uid: session[:uid])
      session[:provider] = nil
      session[:uid] = nil
      redirect_to root_path, notice: 'You need to confirm your email'
    else
      render 'confirmations/email', locals: { user: user }
    end
  end

  private

  def log_in(service)
    @user = User.find_for_oauth(service)
    if @user&.persisted? && @user&.confirmed_at?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: service.provider.capitalize) if is_navigational_format? && service
    elsif @user&.persisted? && !@user&.confirmed_at?
      flash[:alert] = 'You need to confirm your email'
      redirect_to new_user_session_path
    elsif service
      session[:provider] = service[:provider]
      session[:uid] = service[:uid].to_s
      render 'confirmations/email', locals: { user: @user }
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
