require 'spec_helper'

describe Omniauth::HasCurrentUser do
  let(:extended_class) { Class.new { extend Omniauth::HasCurrentUser } }
  let(:including_class) { Class.new { include Omniauth::HasCurrentUser } }

  # it "returns nil of no user exists" do
  #   # expect(extended_class.current_user).to eq nil
  #   expect(including_class.current_user).to eq nil
  # end

end
