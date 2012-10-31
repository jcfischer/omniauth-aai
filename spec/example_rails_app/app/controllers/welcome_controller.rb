class WelcomeController < ApplicationController
  before_filter :authenticate!, :except => :index
  
  def index
  end

  def protected
  end
end
