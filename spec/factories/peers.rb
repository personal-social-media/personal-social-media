# frozen_string_literal: true

# == Schema Information
#
# Table name: peers
#
#  id              :bigint           not null, primary key
#  domain_name     :string           not null
#  email_hexdigest :string
#  name            :string
#  nickname        :string
#  public_key      :binary           not null
#  status_mask     :bigint           default(0), not null
#  verify_key      :binary
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
FactoryBot.define do
  factory :peer do
    public_key do
      RbNaCl::PrivateKey.generate.public_key.to_s
    end
    verify_key do
      RbNaCl::SigningKey.generate.verify_key.to_s
    end
    domain_name { FFaker::Internet.domain_name }
    name { FFaker::Name.name }
    nickname { (FFaker::Internet.user_name + "000").first(18) }
  end
end
