# frozen_string_literal: true

class CoronavirusForm::UrgentMedicalHelpController < ApplicationController
  skip_before_action :check_first_question

  def submit
    @form_responses = {
      urgent_medical_help: strip_tags(params[:urgent_medical_help]).presence,
    }

    invalid_fields = validate_radio_field(
      controller_name,
      group,
      radio: @form_responses[:urgent_medical_help],
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)
      render controller_path
    else
      update_session_store
      # redirect_to nil
    end
  end

private

  def update_session_store
    session[:urgent_medical_help] = @form_responses[:urgent_medical_help]
  end

  def previous_path
    "/"
  end

  def group
    "help"
  end
end
