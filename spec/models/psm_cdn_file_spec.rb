# frozen_string_literal: true

# == Schema Information
#
# Table name: psm_cdn_files
#
#  id                      :bigint           not null, primary key
#  cache_url               :text
#  parts                   :integer          default(0), not null
#  parts_metadata          :jsonb            not null
#  status                  :string           default("pending"), not null
#  upload_percentage       :integer          default(0), not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  cdn_storage_provider_id :bigint           not null
#  psm_file_variant_id     :bigint           not null
#
# Indexes
#
#  index_psm_cdn_files_on_cdn_storage_provider_id  (cdn_storage_provider_id)
#
# Foreign Keys
#
#  fk_rails_...  (cdn_storage_provider_id => cdn_storage_providers.id)
#  fk_rails_...  (psm_file_variant_id => psm_file_variants.id)
#
require "rails_helper"

RSpec.describe PsmCdnFile, type: :model do
end
