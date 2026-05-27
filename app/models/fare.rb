# Layer - Domain / Model

class Fare < ActiveRecord::Base
  FARE_TYPES = %w[Advance Off-Peak Anytime].freeze

  belongs_to :journey
  has_many :bookings, dependent: :restrict_with_error

  validates :fare_type,   presence: true, inclusion: { in: FARE_TYPES }
  validates :price_pence, presence: true,
                          numericality: { only_integer: true, greater_than: 0 }
  validates :is_flexible, inclusion: { in: [true, false] }

  scope :cheapest_first, -> { order(:price_pence) }
  scope :flexible, -> { where(is_flexible: true) }
  scope :available, -> { where('available_seats IS NULL OR available_seats > 0') }

  def price_in_pounds
    format('£%.2f', price_pence / 100.0)
  end

  def available?
    available_seats.nil? || available_seats.positive?
  end
end