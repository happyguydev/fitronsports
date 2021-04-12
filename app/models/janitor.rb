# == Schema Information
#
# Table name: accounts
#
#  id                     :bigint           not null, primary key
#  active                 :boolean          default(TRUE)
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  first_name             :string
#  last_name              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  locked_at              :datetime
#  name_prefix            :string
#  phone_number           :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  terms_of_service       :boolean          default(FALSE), not null
#  type                   :string           not null
#  unconfirmed_email      :string
#  unlock_token           :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  facility_id            :bigint
#  organisation_id        :bigint
#
# Indexes
#
#  index_accounts_on_confirmation_token    (confirmation_token) UNIQUE
#  index_accounts_on_email                 (email) UNIQUE
#  index_accounts_on_facility_id           (facility_id)
#  index_accounts_on_reset_password_token  (reset_password_token) UNIQUE
#  index_accounts_on_unlock_token          (unlock_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (facility_id => facilities.id)
#  fk_rails_...  (organisation_id => organisations.id)
#
class Janitor < Account
  has_many :requests, foreign_key: :janitor_account_id, dependent: :destroy
  # before_create :skip_confirmation

  # send confirmation email after input first & last name
  def skip_confirmation
    skip_confirmation!
  end

  delegate :name, to: :facility, prefix: true
end
