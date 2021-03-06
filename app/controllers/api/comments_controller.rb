# frozen_string_literal: true

module Api
  class CommentsController < BaseController
    before_action :require_friend
    before_action :require_current_comment, only: %i(destroy update)

    def index
      return create if decrypted_params[:comment].present?

      pagination = PaginationService::Paginate.new(scope: index_scope, params: params, limit: 15)

      @comments = pagination.records
    end

    def create
      @comment = CommentsService::CreateComment.new(comment_params_create, current_peer).call!

      render :create
    rescue ActiveRecord::RecordInvalid, CommentsService::CreateComment::Error => e
      render_encrypted_error(e.message)
    end

    def update
      @comment = CommentsService::UpdateComment.new(comment_params_update, current_comment).call!

      render :create
    rescue ActiveRecord::RecordInvalid => e
      render_encrypted_error(e.message)
    end

    def destroy
      current_comment.destroy
      render json: encrypt_json({ ok: true })
    end

    private
      def comment_params_create
        @comment_params ||= decrypted_params.require(:comment).permit(
          :comment_type, :parent_comment_id, :subject_id, :subject_type,
          *VirtualCommentsService::CommentContent::PERMITTED_CONTENT_ATTRIBUTES,
          signature: []
        )
      end

      def comment_params_update
        @comment_params_update ||= decrypted_params.require(:comment).permit(
          *VirtualCommentsService::CommentContent::PERMITTED_CONTENT_ATTRIBUTES,
          signature: []
        )
      end

      def current_comment
        @current_comment ||= scoped_comments.find_by(id: params[:id])
      end

      def require_current_comment
        render_encrypted_error("Comment not found #{params[:id]}", status: 404) if current_comment.blank?
      end

      def scoped_comments
        current_peer.comments
      end

      def index_params
        @index_params ||= decrypted_params.require(:comments).permit(:subject_id, :subject_type, :parent_comment_id)
      end

      def index_scope
        Comment.where(parent_comment_id: index_params[:parent_comment_id]).includes(:comment_counter, :peer, :reaction_counters).where(
          "comment_counter.subject_id": index_params[:subject_id],
          "comment_counter.subject_type": index_params[:subject_type]
        ).order("comments.id": :desc)
      end
  end
end
