require 'omniauth-shibboleth'
module OmniAuth
  module Strategies
    class Aai < OmniAuth::Strategies::Shibboleth

      # 8 core attributes available for all users
      CORE_ATTRIBUTES = {
        unique_id:                "uniqueID",
        persistent_id:            "persistent-id",
        email:                    "mail",
        first_name:               "givenName",
        last_name:                "surname",
        home_organization:        "homeOrganization",
        home_organization_type:   "homeOrganizationType",
        affiliation:              "affiliation"
      }

      # 8 or more Shibboleth attributes, set by the Service Provider automatically for users with a valid session
      SHIBBOLETH_ATTRIBUTES = {
        entitlement: 'entitlement',
        preferredLanguage: 'preferredLanguage'
        #   :'Shib-Application-ID' => [],
        #   :'Shib-Assertion-01' => [],
        #   :'Shib-Assertion-Count' => [],
        #   :'Shib-Authentication-Instant' => [],
        #   :'Shib-Authentication-Method' => [],
        #   :'Shib-AuthnContext-Class' => [],
        #   :'Shib-Identity-Provider' => [],
        #   :'Shib-Session-ID' => []
      }

      # DEFAULT_FIELDS = [:name, :email, :persistent_id, :unique_id]
      DEFAULT_EXTRA_FIELDS = (SHIBBOLETH_ATTRIBUTES.keys)

      option :uid_field, 'persistent-id'
      option :name_field, 'displayName'
      option :email_field, 'mail'
      option :info_fields, CORE_ATTRIBUTES
      option :extra_fields, DEFAULT_EXTRA_FIELDS

      # Attributes checked to find out if there is a valid shibboleth session
      option :shib_session_id_field, 'Shib-Session-ID'
      option :shib_application_id_field, 'Shib-Application-ID'

      option :request_type, :env
      option :debug, false


      def request_phase
        [
          302,
          {
            'Location' => script_name + callback_path + query_string,
            'Content-Type' => 'text/plain'
          },
          ["You are being redirected to your SWITCHaai IdP for sign-in."]
        ]
      end

      def request_params
        super
      end

      def request_param(key)
        super
      end

      def callback_phase
        super
      end

      def option_handler(option_field)
        super
      end


      uid do
        option_handler(options.uid_field)
      end

      info do
        super
      end

      extra do
        super
      end

    end
  end
end
