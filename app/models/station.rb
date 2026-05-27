# Layer - Domain / Model

class Station < ActiveRecord::Base
  has_many :departing_journeys,
           class_name: 'Journey',
           foreign_key: :origin_id,
           dependent: :restrict_with_error

  has_many :arriving_journeys,
           class_name: 'Journey',
           foreign_key: :destination_id,
           dependent: :restrict_with_error

  validates :name, presence: true
  validates :city, presence: true
  validates :crs_code, presence: true,
                       uniqueness: { case_sensitive: false },
                       format: { with: /\A[A-Z]{3}\z/,
                                 message: 'must be exactly 3 uppercase letters' }

  before_validation { self.crs_code = crs_code&.upcase }

  scope :by_city, ->(city) { where(city: city) }
  scope :ordered, -> { order(:name) }
  scope :search,  ->(q) { where('name ILIKE ?', "%#{q}%") }

  def display_name
    "#{name} (#{crs_code})"
  end
end