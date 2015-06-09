class User <%= options[:persist]  ? "< ActiveRecord::Base" : "" %>
<% if options[:persist] %>
  # attr_accessible :uid
  attr_accessor :aai
  PERSISTENT = true

  def self.update_or_create_with_omniauth_aai(omniauth_aai)
    user = find_or_build_with_uid(omniauth_aai['uid'])
    user.attributes = {
      unique_id:          omniauth_aai.info.unique_id,
      persistent_id:      omniauth_aai.info.persistent_id,
      email:              omniauth_aai.info.email,
      first_name:         omniauth_aai.info.first_name,
      last_name:          omniauth_aai.info.last_name,
      home_organization:  omniauth_aai.info.home_organization,
      # affiliation: omniauth_aai.info.affiliation,
      raw_data:           omniauth_aai.respond_to?(:to_hash) ? omniauth_aai.to_hash : omniauth_aai.inspect
    }
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
<% else %>
  attr_accessor :aai, :uid
  PERSISTENT = false
<% end %>

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

<% if options[:persist] %>
  def marshal
    self.uid
  end

  def self.unmarshal(session_data)
    user = User.find_by_uid(session_data)
  end

  def unmarshal(session_data)
    self.reload
  end
<% else %>
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
 <% end %>
end
