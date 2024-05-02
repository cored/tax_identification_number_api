class TaxIdentificationNumbersController < ApplicationController
rescue_from TaxNumberIdentifications::UnsupportedCountry, with: :unsupported_country
rescue_from TaxNumberIdentifications::InvalidTIN, with: :invalid_tin

  def create
    tin = TaxNumberIdentifications.for(tin_params)

    render json: { success: true }.merge(tin.to_h), status: :ok
  end

  private

  def tin_params
    params.permit(:country, :tin)
  end

  def unsupported_country(e)
    render json: { error: e.message }, status: :not_found
  end

  def invalid_tin(e)
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
