require "rubygems"
require "net/http"
require "uri"
require "json"

class Brewerydb
	attr_accessor :id, :name, :description, :createDate, :updateDate, :status, :statusDisplay, :images, :images_icon, :images_medium, :images_large, :type
end

class Brewery < Brewerydb
	attr_accessor :website, :established, :isOrganic, :images, :images_icon, :images_medium, :images_large, :status, :statusDisplay,
						 :labels, :label_icon, :label_medium, :label_large
end

class Beer < Brewerydb
	attr_accessor :abv, :ibu, :glasswareId, :availableId, :styleId, :isOrganic, :labels, :label_icon, :label_medium, :label_large, :glass, :glass_id, :glass_name, :glass_createDate,
						:available, :available_id, :available_name, :available_description, :style, :style_id, :style_category, :style_categoryId, :style_category_id, :style_category_name, 
						:style_category_createDate, :style_name, :style_description, :style_ibuMin, :style_ibuMax, :style_abvMin, :style_abvMax, :style_srmMin, :style_srmMax, :style_ogMin, 
						:style_fgMin, :style_fgMax, :style_createDate
end

class BrewInfo

	def search_brew(text)
#		brewdb = ENV['BREWDB'] 
    brewdb = "3ffa6988117c643475d83ee843637652"
		uri = URI.parse("http://api.brewerydb.com/v2/search?q=#{text}&key=#{brewdb}&format=json")
		resp = Net::HTTP.get_response(uri)
	end
	
	def get_beer_by_id(id)
		brewdb = ENV['BREWDB'] 
		uri = URI.parse("http://api.brewerydb.com/v2/beer/#{id}?&key=#{brewdb}&format=json")
		resp = Net::HTTP.get_response(uri)
	end
	
	def get_brewery_by_id(id)
		brewdb = ENV['BREWDB'] 
		uri = URI.parse("http://api.brewerydb.com/v2/brewery/#{id}?&key=#{brewdb}&format=json")
		resp = Net::HTTP.get_response(uri)
	end
	
	def get_beer_info( id )
		resp = get_beer_by_id( id )
		beer = Beer.new
		
		if ( resp.code == "200" )
			resp_text = resp.body
			result = JSON.parse( resp_text )
			data = result['data']
			
			if ( data != nil ) #make sure we returned a response
				b = data
				
				beer.id = b["id"]
				beer.name = b["name"]
				beer.description = b["description"]
				beer.createDate = b["createDate"]
				beer.updateDate = b["updateDate"]
				beer.status = b["status"]
				beer.statusDisplay = b["statusDisplay"]
				beer.type = "beer"
				beer.abv = b["abv"]
				beer.ibu = b["ibu"]
				beer.glasswareId = b["glasswareId"]
				beer.availableId = b["availableId"]
				beer.styleId = b["styleId"]
				beer.isOrganic = b["isOrganic"]
				
				beer.glass = b["glass"]
				if !( beer.glass.to_s.empty? )
					beer.glass_id = b["glass"]["id"]
					beer.glass_name = b["glass"]["name"]
				end
				
				beer.labels = b["labels"]
				if !( beer.labels.to_s.empty? )
					beer.label_icon = b["labels"]["icon"]
					beer.label_medium = b["labels"]["medium"]
					beer.label_large = b["labels"]["large"]
				end
				
				beer.available = b["available"]
				if !( beer.available.to_s.empty? )
					beer.available_id = b["available"]["id"]
					beer.available_name = b["available"]["name"]
					beer.available_description = b["available"]["description"]
				end
				
				beer.style = b["style"]
				if !( beer.style.to_s.empty? )
					beer.style_id = b["style"]["id"]
					beer.style_categoryId = b["style"]["categoryId"]
					beer.style_name = b["style"]["name"]
					beer.style_description = b["style"]["description"]
					beer.style_ibuMin= b["style"]["ibuMin"]
					beer.style_ibuMax = b["style"]["ibuMax"]
					beer.style_abvMin = b["style"]["abvMin"]
					beer.style_abvMax = b["style"]["abvMax"]
					beer.style_srmMin = b["style"]["srmMin"]
					beer.style_srmMax = b["style"]["srmMax"]
					beer.style_ogMin = b["style"]["ogMin"]
					beer.style_fgMin = b["style"]["fgMin"]
					beer.style_fgMax = b["style"]["fgMax"]
					beer.style_createDate = b["style"]["createDate"]
					
					beer.style_category = b["style"]["category"]
					if !( beer.style_category.to_s.empty? )
						beer.style_category_id = b["style"]["category"]["id"]
						beer.style_category_name = b["style"]["category"]["name"]
						beer.style_category_createDate = b["style"]["category"]["createDate"]
					end
					
				end # end empty style check
				
			end # end the if statement
			
		else
			# We got a bad response
		end # end the if statement
		
		return beer
		
	end # end get_beer_info method
	
	def get_brewery_info( id )
		resp = get_brewery_by_id( id )
		brewery = Brewery.new
	
		if ( resp.code == "200" )
			resp_text = resp.body
			result = JSON.parse( resp_text )
			data = result['data']
			
			if ( data != nil ) #make sure we returned a response
				b = data
				brewery.id = b["id"]
				brewery.name = b["name"]
				brewery.description = b["description"]
				brewery.website = b["website"]
				brewery.established = b["established"]
				brewery.isOrganic = b["isOrganic"]
				brewery.status = b["status"]
				brewery.statusDisplay = b["statusDisplay"]
				brewery.createDate = b["createDate"]
				brewery.updateDate = b["updateDate"]
				
				brewery.images = b["images"]
				if !( brewery.images.to_s.empty? ) 
					brewery.images_icon = b["images"]["icon"]
					brewery.images_medium = b["images"]["medium"]
					brewery.images_large = b["images"]["large"]
				end
				
			end
			
		else
			# We got a bad response
		end # end the if statement
		
		return brewery
		
	end 
	
	def get_brew_info(text)
		resp = search_brew(text)
		resp_text = resp.body
		json = JSON.parse(resp_text)
		
		brewlist = [] #array to hold the results
		
		if resp.code == "200"
			 result = JSON.parse(resp_text)
			 data = result["data"]

			 if (data != nil) # make sure we returned a response
				data.each do |brewery|
					brew = Brewerydb.new
					brew.id = brewery["id"] #reference properties like this
					brew.name = brewery["name"]
					brew.description = brewery["description"]
					brew.status = brewery["status"]
					brew.statusDisplay = brewery["statusDisplay"]
					brew.createDate = brewery["createDate"]
					brew.updateDate = brewery["updateDate"]
					brew.type = brewery["type"]
					
					if ( brew.type == "brewery" )
						brew.images = brewery["images"]
						if !( brew.images.to_s.empty? ) 
							brew.images_icon = brewery["images"]["icon"]
							brew.images_medium = brewery["images"]["medium"]
							brew.images_large = brewery["images"]["large"]
						end
					end
					
					if ( brew.type == "beer" )
						brew.images = brewery["labels"]
						if !( brew.images.to_s.empty? )
							brew.images_icon = brewery["labels"]["icon"]
							brew.images_medium = brewery["labels"]["medium"]
							brew.images_large = brewery["labels"]["large"]
						end
					end
					
					brewlist << brew
				end
			 end
		 end
		
		return brewlist
		
	end



	
	private :search_brew
	


end #end class