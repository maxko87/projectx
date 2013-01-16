class HomeController < ApplicationController
  
  def index

  	client_ip = remote_ip()
  	@city = request.location.city
  	@location = Geocoder.search(client_ip)
  
  end

end
