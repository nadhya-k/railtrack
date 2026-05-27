# Layer - Domain / Model

class Booking < ActiveRecord::Base
  belongs_to :fare
  has_many :passengers, dependent: :destroy
  has_one :journey, through: :fare

  enum :status, { confirmed: 'confirmed', cancelled: 'cancelled' },
       default: 'confirmed'

  validates :reference, presence: true, uniqueness: true
  validates :status, presence: true
  validate :fare_must_be_available, on: :create

  scope :active, -> { where(status: 'confirmed') }

  def cancel!
    update!(status: 'cancelled')
  end

  def cancelled?
    status == 'cancelled'
  end

  private

  def fare_must_be_available
    return unless fare
    return if fare.available?
    errors.add(:fare, 'has no available seats')
  end
end