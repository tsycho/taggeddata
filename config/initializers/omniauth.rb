# TODO: Remove this line.
# OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV["TAGGEDDATA_GOOGLE_CLIENT_ID"], ENV["TAGGEDDATA_GOOGLE_CLIENT_SECRET"], {
    :skip_jwt => true,
    :prompt => 'select_account'
  }
end
