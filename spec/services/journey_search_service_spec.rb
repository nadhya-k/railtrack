# Layer - Test / Service Unit Test

require 'spec_helper'

RSpec.describe JourneySearchService do
  around { |ex| Timecop.freeze(Time.utc(2026, 6, 1, 8, 0, 0)) { ex.run } }

  let(:london) { create(:station, name: 'London Euston',        crs_code: 'EUS') }
  let(:manc) { create(:station, name: 'Manchester Piccadilly', crs_code: 'MAN') }
  let!(:journey) do
    create(:journey,
           origin: london,
           destination: manc,
           departs_at: Time.utc(2026, 6, 1, 9, 0, 0),
           arrives_at: Time.utc(2026, 6, 1, 11, 10, 0))
  end

  describe '.call' do
    context 'with valid parameters' do
      it 'returns a successful result with matching journeys' do
        result = described_class.call(
          origin_id: london.id,
          destination_id: manc.id,
          departs_after: '2026-06-01T08:00:00'
        )

        expect(result).to be_success
        expect(result.journeys).to include(journey)
      end

      it 'excludes journeys before the requested departure time' do
        early = create(:journey,
                       origin: london,
                       destination: manc,
                       departs_at: Time.utc(2026, 6, 1, 7, 0, 0),
                       arrives_at: Time.utc(2026, 6, 1, 9, 0, 0))

        result = described_class.call(
          origin_id: london.id,
          destination_id: manc.id,
          departs_after: '2026-06-01T08:00:00'
        )

        expect(result.journeys).not_to include(early)
      end
    end

    context 'with missing parameters' do
      it 'returns an error when origin_id is missing' do
        result = described_class.call(
          origin_id: nil,
          destination_id: manc.id,
          departs_after: '2026-06-01T08:00:00'
        )

        expect(result).not_to be_success
        expect(result.error).to eq('origin_id is required')
      end

      it 'returns an error when origin and destination are the same' do
        result = described_class.call(
          origin_id: london.id,
          destination_id: london.id,
          departs_after: '2026-06-01T08:00:00'
        )

        expect(result).not_to be_success
        expect(result.error).to include('must differ')
      end
    end

    context 'with an invalid date format' do
      it 'returns a descriptive error' do
        result = described_class.call(
          origin_id: london.id,
          destination_id: manc.id,
          departs_after: 'not-a-date'
        )

        expect(result).not_to be_success
        expect(result.error).to include('Invalid departs_after format')
      end
    end
  end
end