class User <%= options[:persist]  ? "< ActiveRecord::Base" : "" %>
<% if options[:persist] %>
  attr_accessible :uid
  attr_accessor :aai
  PERSISTENT = true
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

  #def shib_session_id
  #  aai["extra"]["raw_info"]['Shib-Session-ID']
  #end
  #
end
