# frozen_string_literal: true

# == Schema Information
#
# Table name: external_accounts
#
#  id                    :bigint           not null, primary key
#  email_ciphertext      :text
#  name                  :string           not null
#  password_ciphertext   :text
#  public_key_ciphertext :text
#  secret_ciphertext     :text
#  secret_key_ciphertext :text
#  service               :string           not null
#  status                :string           default("initializing"), not null
#  usage                 :string           not null
#  username_ciphertext   :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
FactoryBot.define do
  factory :external_account do
    trait :mega_upload do
      name { :mega_upload }
      service { :mega_upload }
      usage { :permanent_storage }
      email { ENV["MEGA_UPLOAD_EMAIL"] }
      password { ENV["MEGA_UPLOAD_PASSWORD"] }
    end
  end
end
