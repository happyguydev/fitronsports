require 'faker'

Admin.create!(
  email: 'admin@fitronsport.com',
  password: Rails.application.credentials.admin_password
)
=begin
Request.create do |r|
  r.description = Faker::Lorem.paragraphs
  r.title = 'Fixing the crossbars of single bars with cracks'
  r.created_at = 1.day.ago
  r.status = :draft
  r.request_type = :service_request
  r.janitor_account_id = Janitor.first.id
  r.facility_id = Janitor.first.facility_id
end

Request.create do |r|
  r.description = Faker::Lorem.paragraphs
  r.title = 'I want to check the net of the painted basketball court'
  r.created_at = 2.days.ago
  r.status = :sent
  r.request_type = :service_request
  r.janitor_account_id = Janitor.first.id
  r.facility_id = Janitor.first.facility_id
end
150.times do
  Product.create!(
    title: Faker::Commerce.product_name,
    description: Faker::Lorem.paragraphs,
    price_cents: Faker::Commerce.price * 100,
    price_currency: %w[EUR USD GBP].sample,
    isbn: Faker::Code.isbn,
    sku: SecureRandom.hex
  )
end
=end
=begin
Inspector.all.each do |inspector|
  Report.statuses.keys.each do |status|
    report = inspector.reports.create!(
      facility: Facility.first,
      status: status,
      title: Faker::Commerce.product_name
      )

    part1 = report.report_parts.create!(rate: 'good', title: 'Part 1', description: 'Part 1 Description')
    part1.attachments.create!(note: Faker::Lorem.paragraphs[2], image: 'fitron-sport.png')
    part2 = report.report_parts.create!(rate: 'bad', title: 'Part 2', description: 'Part 2 Description')
    part2.attachments.create!(note: Faker::Lorem.paragraphs[1], image: 'fitron-sport.png')
    part3 = report.report_parts.create!(rate: 'problematic', title: 'Part 3', description: 'Part 3 Description')
    part3.attachments.create!(note: Faker::Lorem.paragraphs[3], image: 'fitron-sport.png')
    part4 = report.report_parts.create!(rate: 'good', title: 'Part 4', description: 'Part 4 Description')
    part4.attachments.create!(note: Faker::Lorem.paragraphs[4], image: 'fitron-sport.png')
    part4.attachments.create!(note: Faker::Lorem.paragraphs[5], image: 'fitron-sport.png')
  end
end
=end
