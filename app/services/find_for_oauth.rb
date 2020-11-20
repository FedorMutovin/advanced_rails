class FindForOauth
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]

    user = User.where(email: email).first
    if user
      user.create_authorization(auth)
    else
      user = User.create(email: email, password: set_password, password_confirmation: set_password, confirmed_at: Time.now)
      user.create_authorization(auth)
    end
    user
  end

  private

  def set_password
    @password ||= Devise.friendly_token[0, 20]
  end
end
