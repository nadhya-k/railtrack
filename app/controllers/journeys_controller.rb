# Layer - HTTP / Controller

class JourneysController < ApplicationController
  get '/journeys/search' do
    result = JourneySearchService.call(
      origin_id: params[:origin_id],
      destination_id: params[:destination_id],
      departs_after: params[:departs_after],
      passengers: params.fetch(:passengers, 1)
    )

    if result.success?
      json_response({ journeys: JourneySerializer.collection(result.journeys) })
    else
      unprocessable(result.error)
    end
  end

  get '/journeys/:journey_id/fares' do
    journey = Journey.find(params[:journey_id])
    fares   = journey.fares.available.cheapest_first

    json_response({
      journey_id: journey.id,
      fares: fares.map do |fare|
        {
          id: fare.id,
          type: fare.fare_type,
          price_pence: fare.price_pence,
          is_flexible: fare.is_flexible,
          available_seats: fare.available_seats
        }
      end
    })
  end
end