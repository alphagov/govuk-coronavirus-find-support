# frozen_string_literal: true

class CoronavirusForm::MentalHealthWorriesController < ApplicationController
  def submit
    @form_responses = {
      mental_health_worries: strip_tags(params[:mental_health_worries]).presence,
    }

    invalid_fields = validate_radio_field(
      controller_name,
      "mental_health",
      radio: @form_responses[:mental_health_worries],
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)
      render controller_path
    else
      update_session_store
      #redirect_to nil
    end
  end

private

  def update_session_store
    session[:mental_health_worries] = @form_responses[:mental_health_worries]
  end

  def previous_path; end
end
