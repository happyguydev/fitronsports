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
class Product < ApplicationRecord
  scope :active, -> { where(active: true) }

  validates :title, presence: true
  
  def deactivate
    update_attributes(active: false)
  end
end
