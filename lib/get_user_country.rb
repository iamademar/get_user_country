# GetUserCountry
require 'carmen'
require 'hostip'


class GetUserCountry

  attr_accessor :country_name, :country_code

  def initialize(user_ip)
    @country_name = select_location(user_ip)
    @country_code = Carmen::country_code(@country_name)
  end

  private
    def select_location(user_ip)
      if ENV['RAILS_ENV'] == 'development'
        hip = Hostip.new
        location = locateIp(hip.ip)
      else
        location = locateIp(user_ip)
      end

      location
    end

    def locateIp(ip)
      url = "http://ipinfodb.com/ip_query.php?ip="+ip+"&timezone=false"
      xml_data = Net::HTTP.get_response(URI.parse(url)).body
      xmldoc =  REXML::Document.new(xml_data)

      root = xmldoc.root
      city = ""
      regionName = ""
      countryName = ""

      xmldoc.elements.each("Response/CountryName") {
        |e| countryName << e.text
      }
      countryName
   end
end
