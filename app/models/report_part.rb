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
class ReportPart < ApplicationRecord
  belongs_to :report
  belongs_to :product
  include ImageAttachable
  # has_many :attachments,as: :attachable, dependent: :destroy
  # accepts_nested_attributes_for :attachments, allow_destroy: true

  delegate :title, to: :product, prefix: true
  delegate :id, to: :product, prefix: true

  default_scope -> { order(created_at: :asc) }
  enum rate: {
    good: 'good',
    problematic: 'problematic',
    bad: 'bad'
  }
end
