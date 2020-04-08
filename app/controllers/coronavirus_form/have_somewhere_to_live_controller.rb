# frozen_string_literal: true

class CoronavirusForm::HaveSomewhereToLiveController < ApplicationController
  def submit
    @form_responses = {
      have_somewhere_to_live: strip_tags(params[:have_somewhere_to_live]).presence,
    }

    invalid_fields = validate_radio_field(
      controller_name,
      radio: @form_responses[:have_somewhere_to_live],
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
    session[:have_somewhere_to_live] = @form_responses[:have_somewhere_to_live]
  end

  def previous_path
    "/" # TODO: fix with proper previous path
  end
end
