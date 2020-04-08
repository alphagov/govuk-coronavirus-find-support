# frozen_string_literal: true

class CoronavirusForm::HaveYouBeenMadeUnemployedController < ApplicationController
  def submit
    @form_responses = {
      have_you_been_made_unemployed: strip_tags(params[:have_you_been_made_unemployed]).presence,
    }

    invalid_fields = validate_radio_field(
      controller_name,
      group,
      radio: @form_responses[:have_you_been_made_unemployed],
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)
      render controller_path
    else
      update_session_store
      redirect_to controller: next_question(controller_name), action: "show"
    end
  end

private

  def update_session_store
    session[:have_you_been_made_unemployed] = @form_responses[:have_you_been_made_unemployed]
  end

  def previous_path
    previous_question(controller_name)
  end

  def group
    "being_unemployed"
  end
end
