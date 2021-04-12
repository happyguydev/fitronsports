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
require 'test_helper'

class FacilityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
