# frozen_string_literal: true

class VirtualComment
  class PresenterForComment
    def initialize(comment)
      @comment = comment
    end

    delegate(*VirtualComment::PERMITTED_DELEGATED_METHODS, to: :@comment)
    delegate :id, :peer, :reaction_counters, to: :@comment
  end
end
