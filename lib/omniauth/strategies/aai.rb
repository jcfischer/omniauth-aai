require 'omniauth-shibboleth'
module OmniAuth
  module Strategies
    class Aai < OmniAuth::Strategies::Shibboleth

      # 8 core attributes, which must be available for all users
      CORE_ATTRIBUTES = {
        swiss_ep_uid:          [:'Shib-SwissEP-UniqueID'], 
        first_name:            [:'Shib-InetOrgPerson-givenName'], 
        surname:               [:'Shib-Person-surname'], 
        mail:                  [:'Shib-InetOrgPerson-mail'],
        homeOrganization:      [:'Shib-SwissEP-HomeOrganization'], 
        homeOrganizationType:  [:'Shib-SwissEP-HomeOrganizationType'], 
        affiliation:           [:'Shib-EP-Affiliation']
      }

      # 8 or more Shibboleth attributes, set by the Service Provider automatically if a user has a valid session
      SHIBBOLETH_ATTRIBUTES = { 
        :entitlement => [:'Shib-EP-Entitlement'],
        :preferredLanguage => [:'Shib-InetOrgPerson-preferredLanguage'],
        :'Shib-Application-ID' => [],
        :'Shib-Assertion-01' => [],
        :'Shib-Assertion-Count' => [],
        :'Shib-Authentication-Instant' => [],
        :'Shib-Authentication-Method' => [],
        :'Shib-AuthnContext-Class' => [],
        :'Shib-Identity-Provider' => [],
        :'Shib-Session-ID' => []
      }

      DEFAULT_EXTRA_FIELDS = (CORE_ATTRIBUTES.keys + SHIBBOLETH_ATTRIBUTES.keys)
      DEFAULT_FIELDS = [:name, :email, :swiss_ep_uid ]

      # persistent-id is default uid
      option :uid_field, :'persistent-id'

      option :debug, false

      option :aai_fields, CORE_ATTRIBUTES

      option :aai_extra_fields, SHIBBOLETH_ATTRIBUTES

      option :fields, DEFAULT_FIELDS
      option :extra_fields, DEFAULT_EXTRA_FIELDS

      # # # # #
      # Helper Methods
      # # # # #
      def aai_attributes
        options.aai_extra_fields.merge(options.aai_fields)
      end

      def read_env( attribute_key )
        ([attribute_key] + (aai_attributes[attribute_key] || [])).each do | a |
          v = request.env[a.to_s]
          return v unless v.nil? || v.strip == "" 
        end
      end

      # # # # #
      # Rack 
      # # # # #
      def request_phase
        [ 
          302,
          {
            'Location' => script_name + callback_path + query_string,
            'Content-Type' => 'text/plain'
          },
          ["You are being redirected to Shibboleth SP/IdP for sign-in."]
        ]
      end

      def callback_phase
        super
      end
      
      uid do
        # persistent-id is default uid
        request.env[options.uid_field.to_s] 
      end

      info do
        options.fields.inject({}) do |hash, field|
          case field
          when :name
            hash[field] = "#{read_env(:first_name)} #{read_env(:surname)}"
          when :email
            hash[:email] = read_env(:mail)
          else
            hash[field] = read_env(field.to_s)
          end
          hash
        end
      end

      extra do
        options.extra_fields.inject({:raw_info => {}}) do |hash, field|
          hash[:raw_info][field] = read_env(field.to_s)
          hash
        end
      end

    end
  end
end
