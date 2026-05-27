# Layer - Presentation / Serializer

class StationSerializer
  def initialize(station)
    @station = station
  end

  def as_json
    {
      id: @station.id,
      name: @station.name,
      crs_code: @station.crs_code,
      city: @station.city
    }
  end

  def self.collection(stations)
    stations.map { |s| new(s).as_json }
  end
end