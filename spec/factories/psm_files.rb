# frozen_string_literal: true

# == Schema Information
#
# Table name: psm_files
#
#  id                       :bigint           not null, primary key
#  cdn_storage_status       :string           default("pending"), not null
#  content_type             :string           not null
#  metadata                 :jsonb            not null
#  name                     :string           not null
#  permanent_storage_status :string           default("pending"), not null
#  sha_256                  :string(64)       not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
# Indexes
#
#  index_psm_files_on_metadata  (metadata) USING gin
#  index_psm_files_on_sha_256   (sha_256) UNIQUE
#
FactoryBot.define do
  factory :psm_file do
    cdn_storage_status { :ready }
    permanent_storage_status { :ready }
    name { SecureRandom.hex }
    content_type { "text" }
    metadata { {} }
    sha_256 { SecureRandom.hex(32) }

    trait :test_image do
      content_type { "image" }
    end
  end
end
