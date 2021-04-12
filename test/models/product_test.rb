# == Schema Information
#
# Table name: products
#
#  id          :bigint           not null, primary key
#  active      :boolean          default(TRUE)
#  description :string           not null
#  sku         :string
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
