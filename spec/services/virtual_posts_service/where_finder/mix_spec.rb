# frozen_string_literal: true

require "rails_helper"

RSpec.describe VirtualPostsService::WhereFinder, type: :request do
  include_context "two people"
  let(:posts) { create_list(:post, 2, :with_reactions, :with_comments) }
  let(:other_posts) do
    take_over_wrap! do
      create_list(:post, 2, :with_reactions, :with_comments)
    end
  end
  let(:pagination_params) { ActionController::Parameters.new({}) }

  context "mixed posts" do
    before do
      posts
      setup_my_peer(statuses: :friend)
      setup_other_peer(statuses: :friend)

      RemotePost.where(remote_post_id: other_posts.map(&:id)).update_all(peer_id: other_peer.id, show_in_feed: true)

      Peer.where.not(id: Current.peer.id).find_each do |peer|
        peer.update!(status: %i(friend))
      end
    end

    subject do
      described_class.new(pagination_params, post_type: :standard, show_from_feed_only: true).results
    end

    it "returns 4 post" do
      expect(subject.size).to eq(4)
      subject.each do |v_post|
        expect(v_post).to be_a(VirtualPost)
        VirtualPostPresenter.new(v_post).render.tap do |json|
          expect(json).to be_present
          expect(json[:is_valid]).to be_truthy

          json[:latest_comments].each do |comment|
            peer = comment[:peer]
            expect(peer[:status]).to match_array(:friend)
          end
        end
      end
    end
  end
end
