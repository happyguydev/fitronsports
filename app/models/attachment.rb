# == Schema Information
#
# Table name: attachments
#
#  id              :bigint           not null, primary key
#  attachable_type :string           not null
#  image           :jsonb
#  note            :string
#  position        :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  attachable_id   :bigint           not null
#
# Indexes
#
#  index_attachments_on_attachable_type_and_attachable_id  (attachable_type,attachable_id)
#
class Attachment < ApplicationRecord
  belongs_to :attachable, polymorphic: true, touch: true
  mount_uploader :image, ImageUploader

  scope :not_original, -> { where("note != '![*edited*]'") }
end
