# Layer - Business Logic / Service Object

class ReferenceGenerator
  PREFIX = 'TL'.freeze
  ALPHABET = ('A'..'Z').to_a + ('0'..'9').to_a - %w[0 O I L 1].freeze
  REFERENCE_LENGTH = 5
  MAX_ATTEMPTS = 10

  def self.generate
    MAX_ATTEMPTS.times do
      ref = build_reference
      return ref unless Booking.exists?(reference: ref)
    end
    raise "Could not generate a unique booking reference after #{MAX_ATTEMPTS} attempts"
  end

  def self.build_reference
    random_part = Array.new(REFERENCE_LENGTH) { ALPHABET.sample }.join
    "#{PREFIX}-#{random_part}"
  end
  private_class_method :build_reference
end