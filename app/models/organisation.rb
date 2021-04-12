# == Schema Information
#
# Table name: organisations
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Organisation < ApplicationRecord
end
