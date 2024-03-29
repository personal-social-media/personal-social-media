# frozen_string_literal: true

require "rails_helper"

RSpec.describe EncryptionService::EncryptFile do
  describe "#call!" do
    let(:output_file_path) { "/tmp/sample-encryption-file" }
    let(:key) { SecureRandom.bytes(32) }
    let(:iv) { SecureRandom.bytes(16) }
    subject do
      described_class.new(Rails.root.join("LICENSE"), output_file_path, key, iv).call!
    end

    after do
      File.delete(output_file_path)
    end

    it "encrypts a file" do
      expect(subject).to be_a(EncryptionService::EncryptFile::EncryptedFile)

      expect(File.exist?(output_file_path)).to be_truthy
    end
  end
end
