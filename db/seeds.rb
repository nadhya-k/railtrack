# Layer - Infrastructure / Database

# Run with: bundle exec rake db:seed

puts 'Seeding database...'

stations = {
  'EUS' => { name: 'London Euston',         city: 'London',     lat: 51.5284, lng: -0.1331 },
  'KGX' => { name: 'London Kings Cross',    city: 'London',     lat: 51.5308, lng: -0.1238 },
  'MAN' => { name: 'Manchester Piccadilly', city: 'Manchester', lat: 53.4771, lng: -2.2309 },
  'BHM' => { name: 'Birmingham New Street', city: 'Birmingham', lat: 52.4778, lng: -1.9001 },
  'EDB' => { name: 'Edinburgh Waverley',    city: 'Edinburgh',  lat: 55.9521, lng: -3.1897 },
  'LDS' => { name: 'Leeds',                 city: 'Leeds',      lat: 53.7953, lng: -1.5490 }
}

station_records = {}
stations.each do |crs, attrs|
  station_records[crs] = Station.find_or_create_by!(crs_code: crs) do |s|
    s.name      = attrs[:name]
    s.city      = attrs[:city]
    s.latitude  = attrs[:lat]
    s.longitude = attrs[:lng]
  end
  puts "  Station: #{attrs[:name]}"
end

tomorrow = Date.tomorrow

[
  { origin: 'EUS', dest: 'MAN', departs: '09:03', arrives: '11:10', operator: 'Avanti West Coast', code: 'VT1001' },
  { origin: 'EUS', dest: 'MAN', departs: '11:03', arrives: '13:10', operator: 'Avanti West Coast', code: 'VT1002' },
  { origin: 'KGX', dest: 'EDB', departs: '08:00', arrives: '12:30', operator: 'LNER',              code: 'LR2001' },
  { origin: 'EUS', dest: 'BHM', departs: '09:20', arrives: '10:25', operator: 'Avanti West Coast', code: 'VT3001' },
  { origin: 'KGX', dest: 'LDS', departs: '10:00', arrives: '12:10', operator: 'LNER',              code: 'LR4001' }
].each do |j|
  departs = Time.parse("#{tomorrow} #{j[:departs]} UTC")
  arrives = Time.parse("#{tomorrow} #{j[:arrives]} UTC")

  journey = Journey.find_or_create_by!(service_code: j[:code]) do |jrn|
    jrn.origin      = station_records[j[:origin]]
    jrn.destination = station_records[j[:dest]]
    jrn.departs_at  = departs
    jrn.arrives_at  = arrives
    jrn.operator    = j[:operator]
  end
  puts "  Journey: #{j[:origin]} -> #{j[:dest]} at #{j[:departs]}"

  [
    { fare_type: 'Advance',  price_pence: 3500,  is_flexible: false, available_seats: 12 },
    { fare_type: 'Off-Peak', price_pence: 7200,  is_flexible: false, available_seats: nil },
    { fare_type: 'Anytime',  price_pence: 14500, is_flexible: true,  available_seats: nil }
  ].each do |fare_attrs|
    Fare.find_or_create_by!(journey: journey, fare_type: fare_attrs[:fare_type]) do |f|
      f.price_pence     = fare_attrs[:price_pence]
      f.is_flexible     = fare_attrs[:is_flexible]
      f.available_seats = fare_attrs[:available_seats]
    end
  end
end

puts 'Seeding complete!'