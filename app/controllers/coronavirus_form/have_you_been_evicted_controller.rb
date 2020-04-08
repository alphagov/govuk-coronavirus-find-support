# frozen_string_literal: true

class CoronavirusForm::HaveYouBeenEvictedController < ApplicationController
  def submit
    @form_responses = {
      have_you_been_evicted: strip_tags(params[:have_you_been_evicted]).presence,
    }

    invalid_fields = validate_radio_field(
      controller_name,
      group,
      radio: @form_responses[:have_you_been_evicted],
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
    session[:have_you_been_evicted] = @form_responses[:have_you_been_evicted]
  end

  def previous_path
    "/" # TODO: fix with proper previous path
  end

  def group
    "somewhere_to_live"
  end
end
