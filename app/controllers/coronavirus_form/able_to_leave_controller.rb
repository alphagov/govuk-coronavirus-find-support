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
      write_responses
      redirect_to results_url
    end
  end

private

  # We're using this method to reduce the precision of timekeeping so that
  # responses cannot be correlated with analytics data
  def time_hour_floor
    Time.current.beginning_of_hour
  end

  def write_responses
    redacted_session = session.to_hash.without("session_id", "_csrf_token")
    unless smoke_tester?
      FormResponse.create(
        form_response: redacted_session,
        created_at: time_hour_floor,
      )
    end
  end

  def smoke_tester?
    smoke_test_header = request.env["HTTP_SMOKE_TEST"]
    smoke_test_header.present? && smoke_test_header == "true"
  end

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
