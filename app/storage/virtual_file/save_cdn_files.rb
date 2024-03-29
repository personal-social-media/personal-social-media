# frozen_string_literal: true

class VirtualFile
  class SaveCdnFiles
    include Memo
    attr_reader :virtual_file, :psm_file, :psm_original_variant
    def initialize(virtual_file, psm_file, psm_original_variant)
      @virtual_file = virtual_file
      @psm_file = psm_file
      @psm_original_variant = psm_original_variant
    end

    def call
      psm_cdn_files.each do |psm_cdn_file|
        psm_cdn_file.virtual_file = virtual_file
      end

      psm_cdn_files.group_by(&:cdn_storage_provider).each do |cdn_storage_provider, grouped_psm_cdn_files|
        uploaded_files = grouped_psm_cdn_files.map do |psm_cdn_file|
          psm_cdn_file.psm_file_variant.chunked_variant_file.uploaded_files.tap do |up_files|
            psm_cdn_file.parts = up_files.size
          end
        end.flatten

        cdn_storage_provider.upload_multi(uploaded_files)
      end

      psm_cdn_files.each do |psm_cdn_file|
        psm_cdn_file.status = :ready
        psm_cdn_file.save!
        psm_cdn_file.psm_file_variant.clean_variant_file!
      end
    end

    private
      def cdn_storage_providers
        @cdn_storage_providers ||= CdnStorageProvider.where(enabled: true)
      end

      def variants
        memo(:@variants) do
          all_variants = PsmFileVariant::CreateOtherVariantsForFile.new(psm_file, virtual_file.original_physical_file).save!
          all_variants << psm_original_variant
          all_variants
        end
      end

      def notify_progress
        @notify_progress ||= UploadsService::NotifyProgress.new
      end

      def psm_cdn_files
        memo(:@psm_cdn_files) do
          cdn_storage_providers.map do |cdn_storage_provider|
            variants.map do |variant|
              PsmCdnFile.new(psm_file_variant: variant, cdn_storage_provider: cdn_storage_provider)
            end
          end.flatten
        end
      end
  end
end
