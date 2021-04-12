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
class Request < ApplicationRecord
  include ImageAttachable

  belongs_to :janitor, foreign_key: :janitor_account_id
  belongs_to :facility
  belongs_to :product, optional: true

  validates :uid, uniqueness: true
  before_validation :generate_uid

  enum status: {
    sent: 'sent',
    draft: 'draft',
    complete: 'accepted',
    archived: 'archived'
  }, _suffix: true

  enum request_type: {
    service_request: 'service_request',
    order_request: 'order_request'
  }

  # has_many :attachments,as: :attachable, dependent: :destroy
  # accepts_nested_attributes_for :attachments, allow_destroy: true

  default_scope -> { order(updated_at: :desc) }
  scope :active, -> { where(deleted: nil) }

  def ref_number
    (self.request_type == 'service_request' ? 'S-' : 'P-') + self.id.to_s
  end

  def delete_request
    update_attributes(deleted: DateTime.current) 
  end

  private

  def generate_uid
    if !self.uid || self.uid == ""
      self.uid = I18n.transliterate(self.title).downcase.gsub(/\W+/, "-")+ '-' + SecureRandom.urlsafe_base64(4)
    end
  end

end
