namespace :generate_uuid do
  desc "Generate UID for requests"
  task requests_uid: :environment do
    puts "nice"
    Request.where(uid: nil).each do |req|
      uid = I18n.transliterate(req.title).downcase.gsub(/\W+/, "-")+ '-' + SecureRandom.urlsafe_base64(4)
      req.update_attributes(uid: uid)
    end
  end

  desc "Generate UID for reports"
  task reports_uid: :environment do
    Report.where(uid: nil).each do |rep|
      uid = I18n.transliterate(rep.title).downcase.gsub(/\W+/, "-")+ '-' + SecureRandom.urlsafe_base64(4)
      rep.update_attributes(uid: uid)
    end
  end
end
