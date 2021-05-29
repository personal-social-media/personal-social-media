# frozen_string_literal: true

module Api
  class PostsController < BaseController
    before_action :require_friend
    before_action :current_post, only: %i(show)

    def index
      pagination = PaginationService::Paginate.new(scope: default_scope, params: params, limit: 15)

      @posts = pagination.records
    end

    def show
      @post = current_post
    end

    private
      def default_scope
        Post.ready
      end

      def current_post
        @current_post ||= default_scope.find_by(id: params[:id])
      end

      def require_current_post
        render json: { error: "post not found" }, status: 404 if current_post.blank?
      end
  end
end