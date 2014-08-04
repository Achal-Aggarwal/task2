require "net/http"
require "uri"
require 'json'
require 'pp'

class SearchController < ApplicationController

  def query
  	@countries = {'United States' => 'us', 'Argentina' => 'ar', 'Australia' => 'au', 'Austria' => 'at', 'Bahrain' => 'bh', 'Belgium' => 'be', 'Brazil' => 'br', 'Canada' => 'ca', 'Chile' => 'cl', 'China' => 'cn', 'Colombia' => 'co', 'Czech Republic' => 'cz', 'Denmark' => 'dk', 'Finland' => 'fi', 'France' => 'fr', 'Germany' => 'de', 'Greece' => 'gr', 'Hong Kong' => 'hk', 'Hungary' => 'hu', 'India' => 'in', 'Indonesia' => 'id', 'Ireland' => 'ie', 'Israel' => 'il', 'Italy' => 'it', 'Japan' => 'jp', 'Korea' => 'kr', 'Kuwait' => 'kw', 'Luxembourg' => 'lu', 'Malaysia' => 'my', 'Mexico' => 'mx', 'Netherlands' => 'nl', 'New Zealand' => 'nz', 'Norway' => 'no', 'Oman' => 'om', 'Pakistan' => 'pk', 'Peru' => 'pe', 'Philippines' => 'ph', 'Poland' => 'pl', 'Portugal' => 'pt', 'Qatar' => 'qa', 'Romania' => 'ro', 'Russia' => 'ru', 'Saudi Arabia' => 'sa', 'Singapore' => 'sg', 'South Africa' => 'za', 'Spain' => 'es', 'Sweden' => 'se', 'Switzerland' => 'ch', 'Taiwan' => 'tw', 'Turkey' => 'tr', 'United Arab Emirates' => 'ae', 'United Kingdom' => 'gb', 'Venezuela' => 've'}


  	@what = params[:what]
  	@where = params[:where]
  	@country = params[:country]
  	@sort = params[:sort] != nil ? params[:sort] : 'relevance'
  	@currentPage = params[:page] != nil ? params[:page].to_i : 1


  	@start = (@currentPage-1)*10

  	object = getJobs @what, @where, @country, @sort, @start

  	@jobs = object['results']
  	@totalCount = object['totalResults']
  	@start = object['start']
  	@totalPages = (@totalCount/10.0).ceil.to_i
  	@currentPage = object['pageNumber'].to_i + 1

  	@titles = []
  	@companies = []
  	@locations = []
  	@jobs.each { |e|
  		@titles << e['jobtitle']
  		@companies << e['company']
  		@locations << e['formattedLocationFull']
  	}

  	@titles.uniq!
  	@companies.uniq!
  	@locations.uniq!
  end

	def getResponse(url)
		uri = URI.parse(URI.escape(url))

		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = (uri.scheme == "https")
		request = Net::HTTP::Get.new(uri.request_uri)

		response = http.request(request)

		if response.code == "200"
			return response.body
		end

		return false
	end

	def getJobs q, l, co, sort, start
  		query = 'http://api.indeed.com/ads/apisearch?publisher=6943246902326848&v=2&format=json&latlong=1'
  		query += "&q=#{q}"

  		query += "&l=#{l}" if l != nil
  		query += "&co=#{co}" if co != nil
  		query += "&sort=#{sort}" if sort != nil
  		query += "&start=#{start}" if start != nil

		response = getResponse query

		if response == false
			return false
		end
		obj = JSON.parse(response)

		if obj == false
			return false
		end

		return obj
	end
end
