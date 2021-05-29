# frozen_string_literal: true

module HcaptchaHelper
  def safe_hcaptcha_tags(options = {})
    config = Hcaptcha.configuration
    return if config.secret_key.blank? || config.site_key.blank?
    default_options = { callback: :hcaptchaSuccess }
    hcaptcha_tags(options.merge(default_options))
  end

  def verify_hcaptcha_filter
    return unless Rails.env.production?
    token = hcaptcha_response_token

    if token.blank?
      return handle_recaptcha_error
    end

    unless verify_hcaptcha({ response: hcaptcha_response_token })
      if defined? Bugsnag
        config = Hcaptcha.configuration
        Bugsnag.notify({ token: token, secret_key: config.secret_key, site_key: config.site_key })
      end
      handle_recaptcha_error
    end
  end

  def handle_recaptcha_error
    flash_error("invalid recaptcha")
    redirect_back(fallback_location: root_path)
  end
end
