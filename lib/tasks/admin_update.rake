namespace :admin_update do
  desc "Toggle Admin to Active"
  task toggle_active: :environment do
    Admin.where(active: false).each do |admin|
      admin.update_attributes(active: true)
    end
  end
end
