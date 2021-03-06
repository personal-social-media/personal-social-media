# frozen_string_literal: true

module Api
  class RemotePostsController < BaseController
    before_action :require_friend
    before_action :require_current_post, only: %i(destroy)

    def create
      return @post = current_post if current_post.present?
      @post = RemotePost.find_or_create_by!(create_params.slice(:remote_post_id, :peer)).tap do |r_post|
        r_post.post_type = create_params[:post_type]
        r_post.show_in_feed = RemotePostsService::LimitShowInFeed.new(r_post).call unless r_post.persisted?
        r_post.save!
      end

      render json: encrypt_json({ ok: true })
    end

    def destroy
      current_post.destroy
      render json: encrypt_json({ ok: true })
    end

    private
      def default_scope
        RemotePost.where(peer: current_peer)
      end

      def current_post
        @current_post ||= default_scope.find_by(remote_post_id: params[:id])
      end

      def require_current_post
        render_encrypted_error("Remote post not found #{params[:id]}", status: 404) if current_post.blank?
      end

      def create_params
        return @create_params if defined? @create_params
        permitted_params = decrypted_params.require(:post).permit(:id, :post_type)

        @create_params = {
          remote_post_id: permitted_params[:id],
          peer: current_peer,
          post_type: permitted_params[:post_type]
        }
      end
  end
end
