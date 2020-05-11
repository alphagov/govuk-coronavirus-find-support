# frozen_string_literal: true

class CoronavirusForm::NationController < ApplicationController
  def submit
    @form_responses = {
      nation: strip_tags(params[:nation]).presence,
    }

    invalid_fields = validate_radio_field(
      controller_name,
      group,
      radio: @form_responses[:nation],
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)
      render controller_path
    else
      update_session_store
      redirect_to need_help_with_url
    end
  end

private

  def update_session_store
    session[:nation] = @form_responses[:nation]
  end

  def group
    "location"
  end

  def previous_path
    "/"
  end
end
