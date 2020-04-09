# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ActionView::Helpers::SanitizeHelper
  include FieldValidationHelper
  include QuestionsHelper

  rescue_from ActionController::InvalidAuthenticityToken, with: :session_expired

  def show
    @form_responses = session.to_hash.with_indifferent_access
    respond_to do |format|
      format.html { render controller_path }
    end
  end

  if ENV["REQUIRE_BASIC_AUTH"]
    http_basic_authenticate_with(
      name: ENV.fetch("BASIC_AUTH_USERNAME"),
      password: ENV.fetch("BASIC_AUTH_PASSWORD"),
    )
  end

private

  helper_method :previous_path, :group

  def previous_path
    raise NotImplementedError, "Define a previous path"
  end

  def group; end

  def log_validation_error(invalid_fields)
    logger.info do
      {
        validation_error: { text: invalid_fields.pluck(:text).to_sentence },
      }.to_json
    end
  end

  def session_expired
    reset_session
    redirect_to session_expired_path
  end

  def check_filter_question_answered
    if questions_to_ask.blank?
      redirect_to controller: "need_help_with", action: "show"
    end
  end
end
