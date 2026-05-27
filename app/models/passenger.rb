# Layer - Domain / Model

class Passenger < ActiveRecord::Base
  RAILCARD_TYPES = %w[16-25 Network Senior HM-Forces Disabled].freeze

  belongs_to :booking

  validates :name, presence: true
  validates :railcard, inclusion: { in: RAILCARD_TYPES }, allow_nil: true
end