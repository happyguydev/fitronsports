# == Schema Information
#
# Table name: reports
#
#  id                   :bigint           not null, primary key
#  accepted_at          :datetime
#  deleted              :datetime
#  failed_to_send       :boolean          default(FALSE)
#  rejected_at          :datetime
#  sent_at              :datetime
#  status               :enum             default("draft"), not null
#  title                :string
#  uid                  :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  facility_id          :bigint           not null
#  inspector_account_id :bigint           not null
#
# Indexes
#
#  index_reports_on_facility_id           (facility_id)
#  index_reports_on_inspector_account_id  (inspector_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (facility_id => facilities.id)
#
require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
