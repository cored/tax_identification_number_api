require_relative 'tax_number_identifications/au'
require_relative 'tax_number_identifications/ca'
require_relative 'tax_number_identifications/in'

module TaxNumberIdentifications
  InvalidTIN = Class.new(StandardError)
  UnsupportedCountry = Class.new(StandardError)

  def self.for(tin_params)
    country = tin_params[:country].upcase
    tin = tin_params[:tin].upcase

    const_get("#{country}").from(tin)
  rescue NameError
    raise UnsupportedCountry.new("unsupported country #{country}")
  end
end
