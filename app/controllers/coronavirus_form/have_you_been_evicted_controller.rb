# frozen_string_literal: true

class CoronavirusForm::HaveYouBeenEvictedController < ApplicationController
  before_action :check_filter_question_answered
  before_action :check_current_question_selected

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
    elsif last_question == controller_name
      update_session_store
      write_responses
      redirect_to results_url
    else
      update_session_store
      redirect_to polymorphic_url(next_question(controller_name))
    end
  end

private

  def update_session_store
    session[:have_you_been_evicted] = @form_responses[:have_you_been_evicted]
  end

  def previous_path
    polymorphic_path(previous_question(controller_name))
  end

  def group
    "somewhere_to_live"
  end
end
