class User <%= options[:persist]  ? "< ActiveRecord::Base" : "" %>
<% if options[:persist] -%>
  PERSISTENT = true

  def self.update_or_create_with_omniauth_aai(omniauth_aai)
    where(provider: omniauth_aai.provider, uid: omniauth_aai.uid).first_or_create do |user|
      user.provider           = omniauth_aai.provider,
      user.uid                = omniauth_aai.uid,
      user.unique_id          = omniauth_aai.info.unique_id,
      user.persistent_id      = omniauth_aai.info.persistent_id,
      user.email              = omniauth_aai.info.email,
      user.first_name         = omniauth_aai.info.first_name,
      user.last_name          = omniauth_aai.info.last_name,
      user.home_organization  = omniauth_aai.info.home_organization,
      # user.affiliation      = omniauth_aai.info.affiliation,
      user.raw_data           = omniauth_aai.respond_to?(:to_hash) ? omniauth_aai.to_hash : omniauth_aai.inspect
      user.save
    end
  end

  def name
    "#{first_name} #{last_name}"
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

<% else -%>
  attr_accessor :aai, :uid
  PERSISTENT = false

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
    {
      id: self.uid,
      aai: aai.present? ? aai[:info] : {}
    }
  end

  def self.unmarshal(session_data)
    user = User.new
    user.unmarshal(session_data)
    return user
  end

  def unmarshal(session_data)
    self.uid = session_data[:id]
    self.aai = session_data[:aai]
  end
<% end -%>
end
