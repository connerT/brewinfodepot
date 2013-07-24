#!/usr/bin/env ruby
require "net/http"
require "uri"
require "nokogiri"

class Flickr

  attr_accessor :id, :owner, :secret, :server, :farm, :title, :ispublic, :isfriend, :isfamily, :photo_url, 
					   :photo_square,  # w = 75, h = 75, ext = s
					   :photo_large_square, # w = 150, h = 150, ext = q
					   :photo_thumbnail, # w = 100, h = 75, ext = t
					   :photo_small, # w = 240, h = 180, ext = m
					   :photo_small_320, # w = 320, h = 240, ext = n 
					   :photo_medium, # w = 500, h = 375, ext = none
					   :photo_medium_640, # w = 640, h = 480, ext = z
					   :photo_medium_800, # w = 800, h = 600, ext = c
					   :photo_large, # w = 1024, h = 768, ext = b
					   :photo_original # ext = o

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
  
  # probably won't need this method. just prepend correct extension onto url
  def get_sizes(id)
	uri = URI.parse("http://api.flickr.com/services/rest/?method=flickr.photos.getSizes&api_key=756d74d6303e66f5c305f2d24df19dfe&photo_id=#{id}")	
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
      fp.owner = photo['owner']
      fp.secret = photo['secret']
      fp.server = photo['server']
      fp.farm = photo['farm']
      fp.title = photo['title']
      fp.ispublic = photo['ispublic']
      fp.isfriend = photo['isfriend']
      fp.isfamily = photo['isfamily']
      fp.photo_url = create_photo_url(fp.farm, fp.server, fp.id, fp.secret)
	  short_url = fp.photo_url[0..-5]
	  fp.photo_square = short_url + "_s.jpg"
	  fp.photo_large_square = short_url + "_q.jpg"
	  fp.photo_thumbnail = short_url + "_t.jpg"
	  fp.photo_small = short_url + "_m.jpg"
	  fp.photo_small_320 = short_url + "_n.jpg"
	  fp.photo_medium = fp.photo_url
	  fp.photo_medium_640 = short_url + "_z.jpg"
	  fp.photo_medium_800 = short_url + "_c.jpg"
	  fp.photo_large = short_url + "_b.jpg"
	  fp.photo_original = short_url + "_o.jpg"
    
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