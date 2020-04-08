# frozen_string_literal: true

class CoronavirusForm::SelfEmployedController < ApplicationController
  def submit
    @form_responses = {
      self_employed: strip_tags(params[:self_employed]).presence,
    }

    invalid_fields = validate_radio_field(
      controller_name,
      radio: @form_responses[:self_employed],
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
    session[:self_employed] = @form_responses[:self_employed]
  end

  def previous_path; end
end
