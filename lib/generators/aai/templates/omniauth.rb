Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env.development?
    provider :developer, {
      uid_field: 'persistent-id', #:'persistent-id', :unique_id
      fields: [:name, :email, :persistent_id, :unique_id]
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
  end
end
