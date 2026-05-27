# Layer - HTTP / Controller

class StationsController < ApplicationController
  get '/stations' do
    stations = if params[:city]
                 Station.by_city(params[:city]).ordered
               else
                 Station.ordered
               end

    json_response({ stations: StationSerializer.collection(stations) })
  end

  get '/stations/:id' do
    station = Station.find(params[:id])
    json_response({ station: StationSerializer.new(station).as_json })
  end
end