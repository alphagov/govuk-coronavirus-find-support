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

  def set_session_history
    if session[:current_path] != request.path
      session[:previous_path] = session[:current_path]
    end
    session[:current_path] = request.path
  end

  def first_question_path
    "urgent_medical_help".dasherize
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
    redirect_to session_expired_url
  end

  def check_first_question_answered
    if questions_to_ask.blank?
      redirect_to need_help_with_url
    end
  end

  def check_current_question_selected
    session_expired unless questions_to_ask.include?(controller_name)
  end

  def check_session_exists
    session_expired unless last_question_seen?
  end
end
