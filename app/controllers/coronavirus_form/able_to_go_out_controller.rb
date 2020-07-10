# frozen_string_literal: true

class CoronavirusForm::AbleToGoOutController < ApplicationController
  before_action :check_filter_question_answered

  def submit
    @form_responses = {
      able_to_go_out: strip_tags(params[:able_to_go_out]).presence,
    }

    invalid_fields = validate_radio_field(
      controller_name,
      group,
      radio: @form_responses[:able_to_go_out],
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)
      render controller_path
    else
      update_session_store
      write_responses if last_question == controller_name
      redirect_to polymorphic_url(next_question(controller_name))
    end
  end

private

  def update_session_store
    session[:able_to_go_out] = @form_responses[:able_to_go_out]
  end

  def group
    "getting_food"
  end

  def previous_path
    polymorphic_path(previous_question(controller_name))
  end
end