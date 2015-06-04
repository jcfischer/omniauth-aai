Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env.development?
    provider :developer, {
      uid_field: :'persistent-id', #:'persistent-id', :unique_id
      # info_fields: [:name, :email, :'persistent-id']#,
      # extra_fields: [:name, :email, :'persistent-id', :'givenName', :surname, :'homeOrganization']
      fields: OmniAuth::Strategies::Aai::DEFAULT_FIELDS,
      # extra_fields: OmniAuth::Strategies::Aai::DEFAULT_EXTRA_FIELDS
    }
  else
    provider :aai, {
      uid_field:      "uid",
      name_field:     "displayName",
      info_fields: {
        email:        "mail",
        first_name:   "givenName",
        last_name:    "surname"
      }
      # ToDo: persistent-id and UniqueID
      # extra_fields: []
    }
  end
end
