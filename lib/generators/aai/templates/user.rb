class User <%= options[:persist]  ? "< ActiveRecord::Base" : "" %>
  <% if options[:persist] %>
    attr_accessible :uid
    attr_accessor :aai
  <% else %>
    attr_accessor :aai, :uid
  <% end %>

  def name
    aai[:info][:name]
  rescue
    nil
  end

  def email
    auth_hash[:info][:email]
  rescue
    nil
  end

  #def ship_session_id
  #  aai["extra"]["raw_info"]['Shib-Session-ID']
  #end
  #
end