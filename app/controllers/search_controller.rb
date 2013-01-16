class SearchController < ApplicationController

  def index

  	#find metro ID
  	loc = params[:location].gsub(" ", "%20")
  	location_request = open("http://api.songkick.com/api/3.0/search/locations.json?query=#{loc}&apikey=#{$SONGKICK_API_KEY}").read
  	metro_id = ActiveSupport::JSON.decode(location_request)["resultsPage"]["results"]["location"][0]["metroArea"]["id"]
  	
  	#use metro ID to find upcoming venues
  	events_request = open("http://api.songkick.com/api/3.0/metro_areas/#{metro_id}/calendar.json?apikey=#{$SONGKICK_API_KEY}").read
  	@venue_events_json = JSON.parse(events_request)

  	#find artist id
  	artist = params[:artist].gsub(" ", "%20")
  	artist_id_request = open("http://api.songkick.com/api/3.0/search/artists.json?query=#{artist}&apikey=#{$SONGKICK_API_KEY}").read
  	artist_id = ActiveSupport::JSON.decode(artist_id_request)["resultsPage"]["results"]["artist"][0]["id"]

  	#use artist ID to find upcoming events
  	artist_request = open("http://api.songkick.com/api/3.0/artists/#{artist_id}/calendar.json?apikey=#{$SONGKICK_API_KEY}").read
  	@artist_json = JSON.parse(artist_request)

	
  	#search our artists events for our venue
  	@matching_events = []
  	if not @artist_json.kind_of?(Array) then @artist_json = [@artist_json] end

  	@artist_json.each do |resultsPage|
  		resultsPage["resultsPage"]["results"]["event"].each do |event|
  			if event["venue"]["metroArea"]["id"] == metro_id
  				@matching_events += [event]
  			end
  		end
  	end
  	
  	puts JSON.pretty_generate(@matching_events)

  end

end
