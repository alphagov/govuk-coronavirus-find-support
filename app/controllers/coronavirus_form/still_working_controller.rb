# frozen_string_literal: true

class CoronavirusForm::StillWorkingController < ApplicationController
  before_action :check_filter_question_answered
  before_action :check_current_question_selected

  def submit
    @form_responses = {
      still_working: strip_tags(params[:still_working]).presence,
    }

    invalid_fields = validate_radio_field(
      controller_name,
      group,
      radio: @form_responses[:still_working],
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
    session[:still_working] = @form_responses[:still_working]
  end

  def group
    "going_in_to_work"
  end

  def previous_path
    polymorphic_path(previous_question(controller_name))
  end
end
