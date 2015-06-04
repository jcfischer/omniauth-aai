class User < ActiveRecord::Base

  # attr_accessible :uid
  attr_accessor :aai
  PERSISTENT = true

  def self.update_or_create_with_omniauth_aai(omniauth_aai)
    user = find_or_build_with_uid(omniauth_aai['uid'])
    # if omniauth_aai['extra'] && (aai_extra = omniauth_aai['extra']['raw_info'])
    #   attributes.merge!(
    #     first_name = omniauth_aai['givenName']
    #   )
    # end
    user.attributes = {
      email: omniauth_aai['mail'],
      first_name: omniauth_aai['givenName'],
      last_name: omniauth_aai['surname'],
      home_organization: omniauth_aai['homeOrganization'],
      raw_data: omniauth_aai.respond_to?(:to_hash) ? omniauth_aai.to_hash : omniauth_aai.inspect
    }

    # user.unique_id = omniauth_aai['uniqueID']
    # user.persistent_id = omniauth_aai['persistent-id']
    # user.email = omniauth_aai['mail']
    # user.first_name = omniauth_aai['givenName'] || ''
    # user.last_name = omniauth_aai['surname']
    # user.home_organization = omniauth_aai['homeOrganization']
    # user.raw_data = omniauth_aai.respond_to?(:to_hash) ? omniauth_aai.to_hash : omniauth_aai.inspect

    # user.first_name = lambda {|request_param| request_param.call('givenName') || ''},
    # user.last_name = lambda {|request_param| request_param.call('surname') || ''},
    # user.home_organization = lambda {|request_param| request_param.call('homeOrganization') || ''},
    user.save
    user
  end

  def self.find_or_build_with_uid(aai_uid)
    if aai_uid.present?
      where(uid: aai_uid).first || new(uid: aai_uid)
    else
      new
    end
  end


  def name
    aai[:info][:name]
  rescue
    nil
  end

  def email
    aai[:info][:email]
  rescue
    nil
  end

  def marshal
    self.uid
  end

  def self.unmarshal(session_data)
    user = User.find_by_uid(session_data)
  end

  def unmarshal(session_data)
    self.reload
  end

  #def shib_session_id
  #  aai["extra"]["raw_info"]['Shib-Session-ID']
  #end
  #
end
