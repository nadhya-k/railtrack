# Layer - Business Logic / Service Object

class JourneySearchService
  Result = Struct.new(:journeys, :error, keyword_init: true) do
    def success?
      error.nil?
    end
  end

  def self.call(origin_id:, destination_id:, departs_after:, passengers: 1)
    new(origin_id, destination_id, departs_after, passengers).call
  end

  def initialize(origin_id, destination_id, departs_after, passengers)
    @origin_id = origin_id
    @destination_id = destination_id
    @departs_after = departs_after
    @passengers = passengers.to_i
  end

  def call
    validation_error = validate_inputs
    return Result.new(error: validation_error) if validation_error

    journeys = find_journeys
    Result.new(journeys: journeys, error: nil)
  rescue ArgumentError => e
    Result.new(error: "Invalid departs_after format: #{e.message}")
  end

  private

  def validate_inputs
    return 'origin_id is required' if @origin_id.blank?
    return 'destination_id is required' if @destination_id.blank?
    return 'departs_after is required' if @departs_after.blank?
    return 'origin and destination must differ' if @origin_id.to_s == @destination_id.to_s
    return 'passengers must be between 1 and 9' unless (1..9).include?(@passengers)
    nil
  end

  def find_journeys
    departure_time = Time.parse(@departs_after.to_s).utc

    Journey
      .between(@origin_id, @destination_id)
      .departing_after(departure_time)
      .chronological
      .with_stations
      .with_fares
  end
end