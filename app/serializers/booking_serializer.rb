# Layer - Presentation / Serializer

class BookingSerializer
  def initialize(booking)
    @booking = booking
  end

  def as_json
    {
      reference: @booking.reference,
      status: @booking.status,
      fare: fare_json,
      journey: journey_json,
      passengers: passengers_json,
      created_at: @booking.created_at.iso8601
    }
  end

  private

  def fare_json
    fare = @booking.fare
    {
      id: fare.id,
      type: fare.fare_type,
      price_pence: fare.price_pence,
      is_flexible: fare.is_flexible
    }
  end

  def journey_json
    j = @booking.journey
    {
      id: j.id,
      origin: j.origin.name,
      destination: j.destination.name,
      operator: j.operator,
      departs_at: j.departs_at.iso8601,
      arrives_at: j.arrives_at.iso8601,
      duration_minutes: j.duration_minutes
    }
  end

  def passengers_json
    @booking.passengers.map do |p|
      { name: p.name, railcard: p.railcard }
    end
  end
end