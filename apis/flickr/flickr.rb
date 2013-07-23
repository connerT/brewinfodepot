#!/usr/bin/env ruby
require "net/http"
require "uri"
require "nokogiri"

class Flickr

  attr_accessor :id, :owner, :secret, :server, :farm, :title, :ispublic, :isfriend, :isfamily, :photo_url, :photo_square, :photo_largeSquare, :photo_thumbnail, :photo_small, :photo_medium, :photo_medium_640, :photo_original

end

class FlickrInfo

  def search_photos(text) 
    text = URI.escape(text)
    uri = URI.parse("http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=756d74d6303e66f5c305f2d24df19dfe&tags=#{text}&text=#{text}&sort=relevance&safe_search=1&content_type=1")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    response.code             # => 301
    response.body             # => The body (HTML, XML, blob, whatever)
    return response.body
  end
  
  def get_sizes(id)
	uri = URI.parse("http://api.flickr.com/services/rest/?method=flickr.photos.getSizes&api_key=756d74d6303e66f5c305f2d24df19dfe&photo_id=#{text}")	
	http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    response.code             # => 301
    response.body             # => The body (HTML, XML, blob, whatever)
    return response.body
  end 

  def get_flickr_photos(text) 
    response = search_photos(text)
    xml_resp = Nokogiri::XML(response)
    flickr_photos = Array.new # array to hold our photo objects

    xml_resp.xpath("//photos//photo").map do |photo|
      fp = Flickr.new
      fp.id = photo['id']
	  
	  # make another call to Flickr to get the different photo sizes
	  sizes = get_sizes( fp.id )
	  xml_sizes = Nologiri::XML(sizes)
	  fp.photo_square = xml_sizes
	  
      fp.owner = photo['owner']
      fp.secret = photo['secret']
      fp.server = photo['server']
      fp.farm = photo['farm']
      fp.title = photo['title']
      fp.ispublic = photo['ispublic']
      fp.isfriend = photo['isfriend']
      fp.isfamily = photo['isfamily']
      fp.photo_url = create_photo_url(fp.farm, fp.server, fp.id, fp.secret)
    
      flickr_photos << fp  # add the new photo object to the array
    end
    
    return flickr_photos
  end

  private

  def create_photo_url(farm, server, id, secret)
    #http://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
    return "http://farm#{farm}.staticflickr.com/#{server}/#{id}_#{secret}.jpg"
  end

end

#flck = FlickrInfo.new
#photos = flck.get_flickr_photos('Yazoo Brew')

#photos.each do |photo|
#  puts photo.photo_url
#end