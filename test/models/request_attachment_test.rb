# == Schema Information
#
# Table name: request_attachments
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
#  index_request_attachments_on_attachable_type_and_attachable_id  (attachable_type,attachable_id)
#
require 'test_helper'

class RequestAttachmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
