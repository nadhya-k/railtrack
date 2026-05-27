# Layer - Test / Controller Integration Test

require 'spec_helper'

RSpec.describe BookingsController, type: :controller do
  let!(:station_a) { create(:station, crs_code: 'EUS') }
  let!(:station_b) { create(:station, crs_code: 'MAN') }
  let!(:journey) { create(:journey, origin: station_a, destination: station_b) }
  let!(:fare) { create(:fare, journey: journey, price_pence: 3500, fare_type: 'Advance') }

  describe 'POST /bookings' do
    let(:valid_payload) do
      { fare_id: fare.id, passengers: [{ name: 'Jane Smith', railcard: nil }] }.to_json
    end

    context 'with valid data' do
      it 'returns 201 Created' do
        post '/bookings', valid_payload, 'CONTENT_TYPE' => 'application/json'
        expect(last_response.status).to eq(201)
      end

      it 'returns a booking reference in the response' do
        post '/bookings', valid_payload, 'CONTENT_TYPE' => 'application/json'
        body = JSON.parse(last_response.body, symbolize_names: true)
        expect(body[:booking][:reference]).to match(/\ATL-[A-Z0-9]{5}\z/)
        expect(body[:booking][:status]).to eq('confirmed')
      end

      it 'persists the booking to the database' do
        expect {
          post '/bookings', valid_payload, 'CONTENT_TYPE' => 'application/json'
        }.to change(Booking, :count).by(1)
      end
    end

    context 'with missing fare_id' do
      it 'returns 422 Unprocessable Entity' do
        payload = { passengers: [{ name: 'Jane' }] }.to_json
        post '/bookings', payload, 'CONTENT_TYPE' => 'application/json'
        expect(last_response.status).to eq(422)
      end
    end
  end

  describe 'GET /bookings/:reference' do
    let!(:booking) { create(:booking, fare: fare) }
    let!(:passenger) { create(:passenger, booking: booking, name: 'Alice') }

    it 'returns 200 with booking details' do
      get "/bookings/#{booking.reference}"
      expect(last_response.status).to eq(200)
      body = JSON.parse(last_response.body, symbolize_names: true)
      expect(body[:booking][:reference]).to eq(booking.reference)
      expect(body[:booking][:passengers].first[:name]).to eq('Alice')
    end

    it 'returns 404 for an unknown reference' do
      get '/bookings/TL-ZZZZZ'
      expect(last_response.status).to eq(404)
    end
  end

  describe 'DELETE /bookings/:reference' do
    let!(:booking) { create(:booking, fare: fare, status: 'confirmed') }

    it 'returns 204 No Content' do
      delete "/bookings/#{booking.reference}"
      expect(last_response.status).to eq(204)
    end

    it 'sets the booking status to cancelled' do
      delete "/bookings/#{booking.reference}"
      expect(booking.reload.status).to eq('cancelled')
    end
  end
end