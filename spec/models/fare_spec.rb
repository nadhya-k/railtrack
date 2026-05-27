# Layer - Test / Model Unit Test

require 'spec_helper'

RSpec.describe Fare, type: :model do
  subject(:fare) { build(:fare, fare_type: 'Advance', price_pence: 3500) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(fare).to be_valid
    end

    it 'is invalid without a fare_type' do
      fare.fare_type = nil
      expect(fare).not_to be_valid
      expect(fare.errors[:fare_type]).to include("can't be blank")
    end

    it 'rejects unknown fare types' do
      fare.fare_type = 'SuperSaver'
      expect(fare).not_to be_valid
    end

    it 'is invalid with a zero price' do
      fare.price_pence = 0
      expect(fare).not_to be_valid
    end

    it 'is invalid with a negative price' do
      fare.price_pence = -100
      expect(fare).not_to be_valid
    end
  end

  describe '#price_in_pounds' do
    it 'converts pence to formatted pound string' do
      fare.price_pence = 3500
      expect(fare.price_in_pounds).to eq('£35.00')
    end
  end

  describe '#available?' do
    it 'returns true when available_seats is nil' do
      fare.available_seats = nil
      expect(fare).to be_available
    end

    it 'returns true when seats remain' do
      fare.available_seats = 3
      expect(fare).to be_available
    end

    it 'returns false when no seats remain' do
      fare.available_seats = 0
      expect(fare).not_to be_available
    end
  end

  describe '.cheapest_first' do
    it 'returns fares ordered by price ascending' do
      journey = create(:journey)
      expensive = create(:fare, journey: journey, price_pence: 10_000)
      cheap = create(:fare, journey: journey, price_pence: 2_000)
      mid = create(:fare, journey: journey, price_pence: 5_000)

      expect(Fare.where(journey: journey).cheapest_first).to eq([cheap, mid, expensive])
    end
  end
end