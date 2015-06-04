Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env.development?
    provider :developer, {
      uid_field:      "persistent_id",
      fields: [:name, :email, :persistent_id, :unique_id]
      # uid_field: 'persistent-id', #:'persistent-id', :unique_id
      # info_fields: [:name, :email, :'persistent-id']#,
      # extra_fields: [:name, :email, :'persistent-id', :'givenName', :surname, :'homeOrganization']
      # extra_fields: OmniAuth::Strategies::Aai::DEFAULT_EXTRA_FIELDS
    }
  else
    provider :aai, {
      uid_field:      "uid",
      name_field:     "displayName",
      info_fields: {
        unique_id:            "uniqueID",
        persistent_id:        "persistent-id",
        email:                "mail",
        first_name:           "givenName",
        last_name:            "surname",
        home_organization:    "homeOrganization",
        preferred_language:   "preferredLanguage",
        affiliation:          "affiliation"
      }
      # extra_fields: []
    }
  end
end
