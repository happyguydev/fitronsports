# == Schema Information
#
# Table name: requests
#
#  id                 :bigint           not null, primary key
#  accepted_at        :datetime
#  additional_notes   :string           default([]), is an Array
#  deleted            :datetime
#  description        :string
#  product_quantity   :integer          default(0)
#  rejected_at        :datetime
#  request_type       :enum             not null
#  sent_at            :datetime
#  status             :enum             default(NULL), not null
#  title              :string
#  uid                :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  facility_id        :bigint           not null
#  janitor_account_id :bigint           not null
#  product_id         :bigint
#
# Indexes
#
#  index_requests_on_facility_id  (facility_id)
#  index_requests_on_product_id   (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (facility_id => facilities.id)
#  fk_rails_...  (product_id => products.id)
#
require 'test_helper'

class RequestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
