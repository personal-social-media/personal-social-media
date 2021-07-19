# frozen_string_literal: true

# == Schema Information
#
# Table name: cdn_storage_providers
#
#  id                  :bigint           not null, primary key
#  adapter             :string           not null
#  enabled             :boolean          default(FALSE), not null
#  free_space_bytes    :string           default(0), not null
#  used_space_bytes    :string           default(0), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  external_account_id :bigint
#
# Indexes
#
#  index_cdn_storage_providers_on_external_account_id  (external_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (external_account_id => external_accounts.id)
#
FactoryBot.define do
  factory :cdn_storage_provider do
    enabled { true }

    trait :local do
      adapter { "FileSystemAdapters::LocalFileSystemAdapter" }
    end
  end
end
