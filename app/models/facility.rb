# == Schema Information
#
# Table name: facilities
#
#  id            :bigint           not null, primary key
#  active        :boolean          default(TRUE)
#  city          :string
#  contact_email :string
#  contact_name  :string
#  facility_type :enum
#  lat           :decimal(10, 6)
#  lon           :decimal(10, 6)
#  name          :string
#  postal_code   :string
#  searchable    :boolean          default(TRUE)
#  street_line1  :string
#  street_line2  :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Facility < ApplicationRecord
  enum facility_type: {
    Schule: 'Schule',
    Sportplatz: 'Sportplatz',
    Spielplatz: 'Spielplatz',
    Fitnessstudio: 'Fitnessstudio',
    Andere: 'Andere'
  }

  before_validation { self.city = self.city.capitalize }

  default_scope -> { order(updated_at: :desc) }
  scope :active, -> { where(active: true) }
  scope :searchable, -> { where(searchable: true)}
  
  validates :facility_type, presence: true
  validates :name, uniqueness: { scope: %i[city], case_sensitive: false }
  validates :city,  presence: true
  validates :postal_code, presence: true
  validates :name, presence: true
  
  def display_address
    address = street_line1
    address = "#{address}, #{street_line2}" if street_line2
    address = "#{address}, #{city}"
    address = "#{address}, #{postal_code}" if postal_code

    address
  end

  def deactivate
    update_attributes(active: false) 
  end
end
