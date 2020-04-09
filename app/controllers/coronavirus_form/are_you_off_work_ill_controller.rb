# frozen_string_literal: true

class CoronavirusForm::AreYouOffWorkIllController < ApplicationController
  before_action :check_filter_question_answered

  def submit
    @form_responses = {
      are_you_off_work_ill: strip_tags(params[:are_you_off_work_ill]).presence,
    }

    invalid_fields = validate_radio_field(
      controller_name,
      group,
      radio: @form_responses[:are_you_off_work_ill],
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
    session[:are_you_off_work_ill] = @form_responses[:are_you_off_work_ill]
  end

  def previous_path
    polymorphic_path(previous_question(controller_name))
  end

  def group
    "being_unemployed"
  end
end
