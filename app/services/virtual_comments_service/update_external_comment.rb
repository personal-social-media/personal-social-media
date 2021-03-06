# frozen_string_literal: true

module VirtualCommentsService
  class UpdateExternalComment
    class Error < StandardError; end
    delegate :peer, to: :cache_comment
    attr_reader :cache_comment, :content, :comment_type

    def initialize(cache_comment, content, comment_type)
      @comment_type = comment_type
      @content = content
      @cache_comment = cache_comment.tap do |comment|
        comment.assign_attributes(update_attributes)
      end
    end

    def call!
      request.run

      return handle_valid_request if request.valid?

      raise Error, "unable to update comment"
    end

    private
      def handle_valid_request
        cache_comment.tap(&:save!)
      end

      def needs_update?
        cache_comment.content != content.saveable_content || cache_comment.comment_type != comment_type
      end

      def local_comment
        @local_comment ||= Comment.find_by(id: cache_comment.remote_comment_id)
      end

      def update_attributes
        {
          content: content.saveable_content,
          comment_type: comment_type,
        }
      end

      def request
        @request ||= HttpService::ApiClient.new(
          url: peer.api_url("/comments/#{cache_comment.remote_comment_id}"),
          method: :patch,
          body: body,
          peer: peer
        )
      end

      def body
        {
          comment: update_attributes.merge(signature: signature)
        }
      end

      def signature
        CommentsService::JsonSignature.new(cache_comment).call
      end
  end
end
