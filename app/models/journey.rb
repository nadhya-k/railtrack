# Layer - Domain / Model

class Journey < ActiveRecord::Base
  belongs_to :origin, class_name: 'Station', foreign_key: :origin_id
  belongs_to :destination, class_name: 'Station', foreign_key: :destination_id
  has_many :fares, dependent: :destroy

  validates :service_code, presence: true
  validates :departs_at, presence: true
  validates :arrives_at, presence: true
  validates :operator, presence: true
  validate :arrival_must_be_after_departure

  scope :between, lambda { |origin_id, destination_id|
    where(origin_id: origin_id, destination_id: destination_id)
  }
  scope :departing_after, ->(time) { where('departs_at >= ?', time) }
  scope :chronological, -> { order(:departs_at) }
  scope :with_stations, -> { includes(:origin, :destination) }
  scope :with_fares, -> { includes(:fares) }

  def duration_minutes
    ((arrives_at - departs_at) / 60).to_i
  end

  def cheapest_fare
    fares.order(:price_pence).first
  end

  private

  def arrival_must_be_after_departure
    return unless departs_at && arrives_at
    return if arrives_at > departs_at
    errors.add(:arrives_at, 'must be after departure time')
  end
end