module OmniauthHelpers
  def mock_auth_hash_github
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
        provider: 'github',
        uid: '123',
        info: { email: 'github@mail.com'},
        credentials: {
            token: 'mock_token',
            secret: 'mock_secret'
        }
    )
  end

  def mock_auth_hash_facebook
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
        provider: 'facebook',
        uid: '321',
        info: { email: 'facebook@mail.com'},
        credentials: {
            token: 'mock_token',
            secret: 'mock_secret'
        }
    )
  end
end
