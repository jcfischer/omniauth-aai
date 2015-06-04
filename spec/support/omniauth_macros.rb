module OmniauthMacros
  def mock_auth_hash
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[:aai] = {
      provider: 'aai',
      uid: '123545',
      user_info: {
        name: 'mockuser'
      }
    }
  end
end
