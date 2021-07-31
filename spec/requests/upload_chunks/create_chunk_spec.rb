# frozen_string_literal: true

require "rails_helper"

RSpec.describe "POST /upload_chunks", type: :request do
  include_context "logged in"
  let(:input_file) { "Gemfile" }
  let(:input_file_size) { SafeFile.size(input_file) }
  let(:chunk_size) { 1.kilobyte }
  let(:chunks) { chunker.call! }
  let(:identifier) { SecureRandom.hex }
  let(:upload) { create(:upload) }
  let(:chunker) do
    PsmFilesService::Utils::FileChunker.new(input_file, chunk_size)
  end

  before do
    expect_any_instance_of(UploadChunksService::UploadChunk).to receive(:trigger_bg_process_file).and_return(true)
  end

  after do
    chunker.clean
  end

  it "uploads chunks and processes a whole file" do
    chunks.each_with_index do |chunk, i|
      make_request(chunk, i + 1)

      expect(response).to have_http_status(:ok)
    end
  end

  def make_request(chunk, chunk_index)
    params = {
      flowIdentifier: identifier,
      flowFilename: input_file,
      flowChunkNumber: chunk_index,
      file: Rack::Test::UploadedFile.new(chunk, "text/plain"),
      flowChunkSize: chunk_size,
      flowTotalSize: input_file_size
    }

    post "/upload_chunks", params: params, headers: { PSM_UPLOAD_ID: upload.id }
  end
end
