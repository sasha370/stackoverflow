module OmniauthMacros
  OmniAuth.config.test_mode = true

  def mock_auth_hash_google
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
                                                                           'provider' => 'Google',
                                                                           'uid' => '123545',
                                                                           'info' => {
                                                                               'email' => 'google_test@google.com',
                                                                           },
                                                                           'credentials' => {
                                                                               'token' => 'mock_token',
                                                                               'secret' => 'mock_secret'
                                                                           }
                                                                       })
    end

  def mock_auth_hash_github
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
                                                                           'provider' => 'Github',
                                                                           'uid' => '123545',
                                                                           'info' => {
                                                                               'email' => 'github_test@github.com',
                                                                           },
                                                                           'credentials' => {
                                                                               'token' => 'mock_token',
                                                                               'secret' => 'mock_secret'
                                                                           }
                                                                       })
  end
end
