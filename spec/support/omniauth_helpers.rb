module OmniauthHelpers
  def mock_auth_hash(provider)
    OmniAuth.config.mock_auth[provider.to_sym] = OmniAuth::AuthHash.new(
        'provider' => provider,
        'uid' => '123456',
        'info' => {
            'email' => 'new@mail.com'
        }
    )
  end
end
