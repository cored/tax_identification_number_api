require 'nokogiri'

module TaxNumberIdentifications
	class AbnQuery
		API_URL = "http://localhost:8080"

		def self.call(abn, http_client= Faraday)
			new(http_client: http_client).call(abn)
		end

		def initialize(http_client:)
			@http_client = http_client
		end

		def call(abn)
			request(abn)
			parse_response
      validate_response!
			parsed_response
		end

		private

    def validate_response!
      raise InvalidTIN.new("ABN is not registered for GST") unless parsed_response.goods_and_services_tax
    end

		def parse_response
			xml_response = Nokogiri::XML(response.body)

			@parsed_response = OpenStruct.new({
				abn: xml_response.at_xpath("//businessEntity/abn").text,
				status: xml_response.at_xpath("//businessEntity/status").text,
				entity_type: xml_response.at_xpath("//businessEntity/entityType").text,
				organisation_name: xml_response.at_xpath("//businessEntity/organisationName").text,
				goods_and_services_tax: xml_response.at_xpath("//businessEntity/goodsAndServicesTax").text == "true",
				effective_to: xml_response.at_xpath("//businessEntity/effectiveTo").text,
				address: {
					state_code: xml_response.at_xpath("//businessEntity/address/stateCode").text,
					postcode: xml_response.at_xpath("//businessEntity/address/postcode").text
				}
			})
		end

		def request(abn)
			@response = http_client.get("#{API_URL}/queryABN?abn=#{abn.tin}")
		end

		attr_reader :http_client, :response, :response_data, :parsed_response
	end
end
