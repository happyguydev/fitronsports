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
class Report < ApplicationRecord
  belongs_to :inspector, foreign_key: :inspector_account_id
  belongs_to :facility

  before_validation :generate_uid

  # signature image attachment below
  has_one :signature,class_name: 'Attachment', as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :signature, allow_destroy: true

  enum status: {
    sent: 'sent',
    draft: 'draft',
    accept: 'accept',
    archived: 'archived'
  }

  has_many :report_parts, dependent: :destroy
  accepts_nested_attributes_for :report_parts, allow_destroy: true
  
  scope :active, -> { where(deleted: nil) }

  validates :uid, uniqueness: true

  default_scope -> { order(updated_at: :desc) }

  delegate :name, to: :facility, prefix: true
  
  def rate_details(include_zero = false)
    report_parts = self.report_parts
    ReportPart.rates.keys.map {|rate| 
      {rate: rate, count: report_parts.filter{|rp| rp.rate == rate}.count}
    }.filter{|rp| 
      include_zero == false ? rp[:count]> 0 : rp[:count]>= 0 
    }
  end

  def ref_number
    'R-' + self.id.to_s
  end

  def delete_report
    update_attributes(deleted: DateTime.current) 
  end

  private

  def generate_uid
    if !self.uid || self.uid == ""
      self.uid = I18n.transliterate(self.title).downcase.gsub(/\W+/, "-")+SecureRandom.urlsafe_base64(4)
    end
  end

end
