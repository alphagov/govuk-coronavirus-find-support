# frozen_string_literal: true

class CoronavirusForm::AbleToLeaveController < ApplicationController
  before_action :check_filter_question_answered

  def submit
    @form_responses = {
      able_to_leave: strip_tags(params[:able_to_leave]).presence,
    }

    invalid_fields = validate_radio_field(
      controller_name,
      group,
      radio: @form_responses[:able_to_leave],
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)
      render controller_path
    else
      update_session_store
      redirect_to results_path
    end
  end

private

  def update_session_store
    session[:able_to_leave] = @form_responses[:able_to_leave]
  end

  def group
    "leave_home"
  end

  def previous_path
    polymorphic_path(previous_question(controller_name))
  end
end
