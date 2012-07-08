class User
  attr_accessor :email, :name, :id, :swiss_ep_uid

  def self.set(auth_hash)
    u = User.new
    u.email = auth_hash[:info][:email] 
    u.name =  auth_hash[:info][:name] 
    u.swiss_ep_uid = auth_hash[:info][:swiss_ep_uid] 
    u.id = auth_hash[:uid]
  end

end