# frozen_string_literal: true

module PeersService
  module Relationships
    class DeclineFriendship
      attr_reader :peer, :request

      def initialize(request)
        @request = request
        @peer = request.record
      end

      def call!
        update_peer!
        make_request!
      end

      private
        def update_peer!
          peer.status -= %i(friendship_requested_by_external)
          peer.status << :friendship_requested_by_me_blocked
          peer.save!
        end

        def make_request!
          request.run_with_retry_in_background
        end
    end
  end
end
