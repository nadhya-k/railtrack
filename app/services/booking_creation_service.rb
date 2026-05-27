# LAYER: Business Logic / Service Object


class BookingCreationService
  Result = Struct.new(:booking, :error, keyword_init: true) do
    def success?
      error.nil?
    end
  end

  def self.call(fare_id:, passengers:)
    new(fare_id, passengers).call
  end

  def initialize(fare_id, passengers)
    @fare_id = fare_id
    @passengers = Array(passengers)
  end

  def call
    validation_error = validate_inputs
    return Result.new(error: validation_error) if validation_error

    booking = create_booking_with_passengers
    Result.new(booking: booking, error: nil)
  rescue ActiveRecord::RecordInvalid => e
    Result.new(error: e.message)
  end

  private

  def validate_inputs
    return 'fare_id is required' if @fare_id.blank?
    return 'at least one passenger is required' if @passengers.empty?
    return 'maximum 9 passengers per booking' if @passengers.size > 9

    fare = Fare.find_by(id: @fare_id)
    return 'fare not found' unless fare
    return 'fare is not available' unless fare.available?
    nil
  end

  def create_booking_with_passengers
    ActiveRecord::Base.transaction do
      booking = Booking.create!(
        fare: Fare.find(@fare_id),
        reference: ReferenceGenerator.generate,
        status: 'confirmed'
      )

      @passengers.each do |passenger_attrs|
        booking.passengers.create!(
          name: passenger_attrs[:name] || passenger_attrs['name'],
          railcard: passenger_attrs[:railcard] || passenger_attrs['railcard']
        )
      end

      booking
    end
  end
end