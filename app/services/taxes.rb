require_relative 'taxes/countries/au'
require_relative 'taxes/countries/ca'
require_relative 'taxes/countries/in'

module Taxes
  InvalidTIN = Class.new(StandardError)
  UnsupportedCountry = Class.new(StandardError)

  def self.for(tin_params)
    country = tin_params[:country].upcase
    tin = tin_params[:tin].upcase

    const_get("Taxes::Countries::#{country}").from(tin)
  rescue NameError
    raise UnsupportedCountry.new("unsupported country #{country}")
  end
end
