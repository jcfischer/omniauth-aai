Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env.development?
    provider :developer, {
      :uid_field => :swiss_ep_uid, #:'persistent-id', swiss_ep_uid
      :fields => OmniAuth::Strategies::Aai::DEFAULT_FIELDS,
      :extra_fields => OmniAuth::Strategies::Aai::DEFAULT_EXTRA_FIELDS
    } 
  else
    provider :aai
  end
end