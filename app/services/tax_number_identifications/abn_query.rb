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
		end

		private

		Response = Struct.new(:abn, :status, :entity_type, :organisation_name, :goods_and_services_tax, :effective_to, :address, keyword_init: true) do
			def self.from_xml(xml_response)
				abn = xml_response.at_xpath("//businessEntity/abn").text
				status = xml_response.at_xpath("//businessEntity/status").text
				entity_type = xml_response.at_xpath("//businessEntity/entityType").text
				organisation_name = xml_response.at_xpath("//businessEntity/organisationName").text
				goods_and_services_tax = xml_response.at_xpath("//businessEntity/goodsAndServicesTax").text == "true"
				effective_to = xml_response.at_xpath("//businessEntity/effectiveTo").text
				address = {
					state_code: xml_response.at_xpath("//businessEntity/address/stateCode").text,
					postcode: xml_response.at_xpath("//businessEntity/address/postcode").text
				}
				new(abn: abn,
						status: status,
						entity_type: entity_type,
						organisation_name: organisation_name,
						goods_and_services_tax: goods_and_services_tax,
						effective_to: effective_to,
						address: address)
			rescue NoMethodError
				raise InvalidTIN.new("ABN is not registered for GST")
			end
		end
		def parse_response
			Response.from_xml(Nokogiri::XML(response.body))
		end

		def request(abn)
			@response = http_client.get("#{API_URL}/queryABN?abn=#{abn.tin}")
		end

		attr_reader :http_client, :response, :response_data, :parsed_response
	end
end
