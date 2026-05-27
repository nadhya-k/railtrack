# LAYER: Presentation / Serializer

class JourneySerializer
  def initialize(journey)
    @journey = journey
  end

  def as_json
    {
      id: @journey.id,
      origin: @journey.origin.name,
      destination: @journey.destination.name,
      operator: @journey.operator,
      departs_at: @journey.departs_at.iso8601,
      arrives_at: @journey.arrives_at.iso8601,
      duration_minutes: @journey.duration_minutes,
      cheapest_fare: cheapest_fare_json
    }
  end

  def self.collection(journeys)
    journeys.map { |j| new(j).as_json }
  end

  private

  def cheapest_fare_json
    fare = @journey.cheapest_fare
    return nil unless fare
    {
      id: fare.id,
      type: fare.fare_type,
      price_pence: fare.price_pence,
      is_flexible: fare.is_flexible
    }
  end
end