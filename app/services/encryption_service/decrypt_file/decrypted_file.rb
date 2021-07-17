# frozen_string_literal: true

module EncryptionService
  class DecryptFile
    class DecryptedFile
      attr_reader :path
      def initialize(path)
        @path = path
      end

      def read
        File.read(path)
      end
    end
  end
end
