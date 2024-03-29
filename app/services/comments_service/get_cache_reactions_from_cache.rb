# frozen_string_literal: true

module CommentsService
  class GetCacheReactionsFromCache
    attr_reader :cache, :parent_record, :comment
    def initialize(cache, parent_record, comment)
      @cache = cache
      @parent_record = parent_record
      @comment = comment
    end

    def call
      return handle_local_comment if comment.is_a?(Comment)
      handle_remote_comment
    end

    def handle_local_comment
      @comment.cache_reactions
    end

    def handle_remote_comment
      @cache.cache_reactions.select do |cache_reaction|
        next false unless cache_reaction.subject_type == "Comment"
        raise peer.to_json if peer.blank?
        cache_reaction.peer == peer && cache_reaction.subject_id == comment.id
      end
    end

    def peer
      return @peer if defined? @peer
      @peer = @parent_record&.peer
    end
  end
end
