class ApplicationController < ActionController::Base
  protect_from_forgery
  
  require 'open-uri'

  $SONGKICK_API_KEY = "q6iZ3qNgMaqbFkaj" #TODO: move this out of rep

  def remote_ip
    if request.remote_ip == '127.0.0.1'
      # Hard coded remote address
      '18.228.1.115'
    else
      request.remote_ip
    end
  end
  
end
