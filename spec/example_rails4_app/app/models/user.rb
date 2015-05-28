class User < ActiveRecord::Base

  attr_accessible :uid
  attr_accessor :aai
  PERSISTENT = true


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
