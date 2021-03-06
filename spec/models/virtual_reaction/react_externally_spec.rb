# frozen_string_literal: true

require "rails_helper"

RSpec.describe VirtualReaction, type: :request do
  include_context "two people"

  describe ".react_for_remote_post" do
    let(:sample_post) { create(:post) }
    let(:remote_post) { create(:remote_post, peer: other_peer, remote_post_id: sample_post.id) }
    let(:sample_react) { build(:cache_reaction) }

    context "externally" do
      before do
        setup_my_peer(statuses: :friend)
        setup_other_peer(statuses: :friend)
      end

      subject do
        described_class.react_for_remote_post(remote_post.id, sample_react.character)
      end

      it "creates a CacheReaction, a Reaction and ReactionCounter" do
        expect do
          subject
        end.to change { CacheReaction.count }.by(1)
          .and change { Reaction.count }.by(1)
          .and change { ReactionCounter.count }.by(1)
      end
    end
  end
end
