# Layer - HTTP / Controller

class BookingsController < ApplicationController
  post '/bookings' do
    result = BookingCreationService.call(
      fare_id:    json_body[:fare_id],
      passengers: json_body[:passengers]
    )

    if result.success?
      json_response(
        { booking: BookingSerializer.new(result.booking).as_json },
        status: 201
      )
    else
      unprocessable(result.error)
    end
  end

  get '/bookings/:reference' do
    booking = Booking.find_by!(reference: params[:reference].upcase)
    json_response({ booking: BookingSerializer.new(booking).as_json })
  end

  delete '/bookings/:reference' do
    booking = Booking.find_by!(reference: params[:reference].upcase)
    booking.cancel! unless booking.cancelled?
    status 204
  end
end