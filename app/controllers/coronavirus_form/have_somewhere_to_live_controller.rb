# frozen_string_literal: true

class CoronavirusForm::HaveSomewhereToLiveController < ApplicationController
  before_action :check_filter_question_answered

  def submit
    @form_responses = {
      have_somewhere_to_live: strip_tags(params[:have_somewhere_to_live]).presence,
    }

    invalid_fields = validate_radio_field(
      controller_name,
      group,
      radio: @form_responses[:have_somewhere_to_live],
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
    session[:have_somewhere_to_live] = @form_responses[:have_somewhere_to_live]
  end

  def previous_path
    polymorphic_path(previous_question(controller_name))
  end

  def group
    "somewhere_to_live"
  end
end
