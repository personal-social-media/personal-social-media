# frozen_string_literal: true

# == Schema Information
#
# Table name: psm_file_variants
#
#  id                       :bigint           not null, primary key
#  cdn_storage_status       :string           default("pending"), not null
#  external_file_name       :string           not null
#  iv_ciphertext            :string           not null
#  key_ciphertext           :string           not null
#  permanent_storage_status :string           default("pending"), not null
#  size_bytes               :bigint           default(0), not null
#  variant_metadata         :jsonb            not null
#  variant_name             :string           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  psm_file_id              :bigint           not null
#
# Indexes
#
#  index_psm_file_variants_on_external_file_name            (external_file_name) UNIQUE
#  index_psm_file_variants_on_psm_file_id_and_variant_name  (psm_file_id,variant_name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (psm_file_id => psm_files.id)
#
class PsmFileVariant < ApplicationRecord
  class NoVariantFile < StandardError; end
  include Memo
  encrypts :key, type: :binary
  encrypts :iv, type: :binary
  attr_accessor :original_physical_file
  attr_reader :variant_file

  belongs_to :psm_file
  has_many :psm_permanent_files, dependent: :destroy
  has_many :psm_cdn_files, dependent: :destroy
  has_many :upload_file_logs, dependent: :nullify
  validates :external_file_name, uniqueness: true
  validates :psm_file_id, uniqueness: { scope: :variant_name }

  after_initialize do |psm_file_variant|
    next if psm_file_variant.persisted?
    psm_file_variant.key ||= SecureRandom.bytes(32)
    psm_file_variant.iv ||= SecureRandom.bytes(16)
  end

  def create_variant_file!
    return if variant_file.present?
    result = PsmFileVariantsService::BuildCustomVariant.new(self).call
    @variant_file = result[:encrypted_file]
    self.variant_metadata = result[:metadata].except(:exif)
    if original?
      update_exif_for_psm_file!(result)
    end
    self.external_file_name = new_variant_file_name
    self.size_bytes = variant_file.size
  end

  def clean_variant_file!
    return if original?
    return unless SafeFile.exist?(variant_file.path)
    SafeFile.delete(variant_file.path)
  end

  def new_variant_file_name
    @new_variant_file_name ||= SecureRandom.hex(50) + SafeFile.extname(original_physical_file)
  end

  def original?
    memo(:@original) do
      variant_name.to_s == "original"
    end
  end

  def chunked_variant_file
    raise NoVariantFile if variant_file.blank?
    memo(:@chunked_variant_file) do
      FileSystemAdapters::ChunkedUploadedFiles.new(external_file_name, variant_file.path)
    end
  end

  private
    def update_exif_for_psm_file!(variant_result)
      psm_file.metadata["exif"] = variant_result[:metadata][:exif]
      psm_file.save!
    end
end
