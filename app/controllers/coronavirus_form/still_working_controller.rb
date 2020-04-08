# frozen_string_literal: true

class CoronavirusForm::StillWorkingController < ApplicationController
  def submit
    @form_responses = {
      still_working: strip_tags(params[:still_working]).presence,
    }

    invalid_fields = validate_radio_field(
      controller_name,
      "going_in_to_work",
      radio: @form_responses[:still_working],
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
    session[:still_working] = @form_responses[:still_working]
  end

  def previous_path; end
end
