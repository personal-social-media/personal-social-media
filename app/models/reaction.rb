# frozen_string_literal: true

# == Schema Information
#
# Table name: reactions
#
#  id                  :bigint           not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  peer_id             :bigint           not null
#  reaction_counter_id :bigint           not null
#
# Indexes
#
#  index_reactions_on_peer_id              (peer_id)
#  index_reactions_on_reaction_counter_id  (reaction_counter_id)
#
# Foreign Keys
#
#  fk_rails_...  (peer_id => peers.id)
#  fk_rails_...  (reaction_counter_id => reaction_counters.id)
#
class Reaction < ApplicationRecord
  delegate :character, :subject_id, :subject_type, to: :reaction_counter
  belongs_to :reaction_counter, counter_cache: true
  belongs_to :peer

  validates :reaction_counter_id, uniqueness: { scope: :peer_id }
end
