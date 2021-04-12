# == Schema Information
#
# Table name: report_parts
#
#  id          :bigint           not null, primary key
#  description :string
#  rate        :enum             default("good"), not null
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  product_id  :bigint           not null
#  report_id   :bigint           not null
#
# Indexes
#
#  index_report_parts_on_product_id  (product_id)
#  index_report_parts_on_report_id   (report_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#  fk_rails_...  (report_id => reports.id)
#
require 'test_helper'

class ReportPartTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
