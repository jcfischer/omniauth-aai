Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env.development?
    provider :developer, {
      :uid_field => :'persistent-id',
      :fields => OmniAuth::Strategies::Aai::DEFAULT_FIELDS,
      :extra_fields => OmniAuth::Strategies::Aai::DEFAULT_EXTRA_FIELDS
    } 
  else
    provider :aai
  end
end