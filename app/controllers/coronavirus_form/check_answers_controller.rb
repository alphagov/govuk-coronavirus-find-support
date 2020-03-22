# frozen_string_literal: true

class CoronavirusForm::CheckAnswersController < ApplicationController
  include ActionView::Helpers::SanitizeHelper

  def show
    if session[:nhs_letter].present?
      session[:check_answers_seen] = true
      render "coronavirus_form/check_answers"
    else
      redirect_to controller: "coronavirus_form/start", action: "show"
    end
  end

  def submit
    submission_reference = reference_number

    session[:reference_id] = submission_reference

    FormResponse.create(
      reference_id: submission_reference,
      unix_timestamp: Time.zone.now,
      form_response: session,
    )

    reset_session

    redirect_to controller: "coronavirus_form/confirmation", action: "show", reference_number: submission_reference
  end

private

  def reference_number
    timestamp = Time.zone.now.strftime("%Y%m%d-%H%M%S")
    random_id = SecureRandom.hex(3).upcase
    "#{timestamp}-#{random_id}"
  end
end
