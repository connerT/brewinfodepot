require "rubygems"
require "net/http"
require "uri"
require "json"

class Brew
	attr_accessor :id, :name, :description, :website, :established, :isOrganic, :images, :status, :statusDisplay, :createDate, :updateDate, :type
end

class BrewInfo

	def search_brew(text)
		uri = URI.parse("http://api.brewerydb.com/v2/search?q=#{text}&key=3ffa6988117c643475d83ee843637652&format=json")
		resp = Net::HTTP.get_response(uri)
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
				brew = Brew.new
				brew.id = brewery["id"] #reference properties like this
				brew.name = brewery["name"]
				brew.description = brewery["description"]
				brew.website = brewery["website"]
				brew.established = brewery["established"]
				brew.isOrganic = brewery["isOrganic"]
				brew.images = brewery["images"]
				brew.status = brewery["status"]
				brew.statusDisplay = brewery["statusDisplay"]
				brew.createDate = brewery["createDate"]
				brew.updateDate = brewery["updateDate"]
				brew.type = brewery["type"]
				
				brewlist << brew
			end
		 end
		 end
		
		return brewlist
		
	end



	
	private :search_brew
	


end #end class