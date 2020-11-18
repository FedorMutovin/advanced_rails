class OauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :session_data, only: %i[github facebook]

  def github
    log_in(session['omniauth.auth'])
  end

  def facebook
    log_in(session['omniauth.auth'])
  end

  def set_email
    session['omniauth.auth']['info']['user_email'] = params[:email]
    log_in(session['omniauth.auth'])
  end

  private

  def log_in(service)
    @user = User.find_for_oauth(service)
    if @user&.persisted? && @user&.confirmed_at?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: service['provider'].capitalize) if is_navigational_format? && service
    elsif @user&.persisted? && !@user&.confirmed_at?
      flash[:alert] = "You need to confirm your email"
      redirect_to new_user_session_path
    elsif service
      render 'confirmations/email', locals: { provider: session['omniauth.auth']['provider'], user: @user }
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def session_data
    session['omniauth.auth'] = request.env['omniauth.auth']
  end
end
