# frozen_string_literal: true

module ErrorsService
  class LogDevError
    class << self
      def log(error)
        if Rails.env.development?
          return print "#{error}\n"
        end

        return unless defined? Bugsnag
        return unless DeveloperService::IsEnabled.is_enabled?
        return if Rails.application.secrets.bugsnag.blank?

        Bugsnag.notify(error)
      end
    end
  end
end
