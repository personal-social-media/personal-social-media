# frozen_string_literal: true

class VirtualComment
  PERMITTED_DELEGATED_METHODS = %i(
    comment_type content sub_comments_count parent_comment_id
    created_at updated_at
  )

  def initialize(comment: nil, json: nil)
    if comment.present?
      @presenter = VirtualComment::PresenterForComment.new(comment)
    elsif json.present?
      @presenter = VirtualComment::PresenterForJson.new(json)
    end
  end

  delegate(*PERMITTED_DELEGATED_METHODS, to: :@presenter)
  delegate :id, :peer, :reaction_counters, to: :@presenter

  class << self
    def where(pagination_params: {}, subject:, parent_comment_id:)
      VirtualCommentsService::WhereFinder.new(
        pagination_params, subject: subject, parent_comment_id: parent_comment_id
      ).results
    end

    def create_comment(subject_type, subject_id, content, parent_comment_id, comment_type)
      VirtualCommentsService::CreateComment.new(subject_type, subject_id, content, parent_comment_id, comment_type).call!
    end

    def update_comment(cache_comment, content, comment_type)
      VirtualCommentsService::UpdateComment.new(cache_comment, content, comment_type).call!
    end

    def remove_comment(cache_comment)
      VirtualCommentsService::RemoveComment.new(cache_comment).call!
    end
  end
end
