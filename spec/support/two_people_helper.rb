# frozen_string_literal: true

class TwoPeopleHelper
  class_attribute :test_ctx
  class << self
    attr_reader :real_profile, :fake_profile, :fake_settings
    def take_over_wrap!
      take_over!
      yield.tap do
        take_over_end
      end
    end

    def take_over!
      return if @take_over_already
      @take_over_already = true
      @real_profile = Current.profile
      @real_settings = Current.settings

      @fake_profile ||= FactoryBot.build(:profile).tap do |profile|
        profile.send(:generate_private_key)
        profile.send(:generate_signing_key)
      end

      Current.__set_manually_profile(@fake_profile)

      @fake_settings ||= FactoryBot.build(:setting)
      Current.__set_manually_settings(@fake_settings)
    end

    def take_over_end
      @take_over_already = false

      return if @real_profile.blank?
      Current.__set_manually_profile(@real_profile)
      Current.__set_manually_settings(@real_settings)
  end
  end
end

RSpec.shared_examples "two people" do
  include RequestsApiSpecHelper

  before do
    TwoPeopleHelper.test_ctx = self
  end

  after do
    TwoPeopleHelper.take_over_end
  end
end