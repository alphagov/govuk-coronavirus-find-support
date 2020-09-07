# frozen_string_literal: true

class CoronavirusForm::AreYouOffWorkIllController < ApplicationController
  before_action :check_filter_question_answered
  before_action :check_current_question_selected

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
      redirect_to polymorphic_url(next_question(controller_name))
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
    "going_in_to_work"
  end
end
