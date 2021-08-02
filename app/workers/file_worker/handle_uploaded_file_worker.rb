# frozen_string_literal: true

module FileWorker
  class HandleUploadedFileWorker < ApplicationWorker
    sidekiq_options retry: 1

    attr_reader :upload_file_record, :psm_file, :virtual_file, :psm_attachment, :subject
    delegate :upload, to: :upload_file_record
    def perform(upload_file_id)
      @upload_file_record = UploadFile.find_by(id: upload_file_id)
      return if upload_file_record.blank?

      @subject = upload.subject

      create_psm_file_record
      mark_upload_file_as_ready!

      return unless all_upload_files_ready?

      update_subject!
      destroy_upload!
    end

    private
      def mark_upload_file_as_ready!
        upload_file_record.update!(status: :ready)
      end

      def create_psm_file_record
        @virtual_file = VirtualFile.new(original_physical_file: uploaded_file).tap do |v_file|
          v_file.save!
        end
        @psm_file = virtual_file.psm_file
        @psm_attachment = PsmAttachment.create!(psm_file: psm_file, subject: subject)
      end

      def uploaded_file
        return @uploaded_file if defined? @uploaded_file
        path = SafeTempfile.generate_new_temp_file_path
        SafeFile.open(path, "wb") do |f|
          upload_file_chunks do |chunks|
            chunks.each do |chunk|
              f.write(chunk.payload)
            end
          end
        end

        @uploaded_file = SafeFile.open(path)
      end

      def upload_file_chunks
        upload_file_record.upload_file_chunks.order(:resumable_chunk_number).find_in_batches(batch_size: 50) do |upload_file_chunks|
          yield upload_file_chunks
        end
      end

      def all_upload_files_ready?
        upload.upload_files.where.not(status: :ready).count.zero?
      end

      def update_subject!
        subject.update!(status: :ready)
      end

      def destroy_upload!
        upload.destroy
      end
  end
end