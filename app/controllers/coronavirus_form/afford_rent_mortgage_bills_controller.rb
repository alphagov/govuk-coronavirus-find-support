# frozen_string_literal: true

class CoronavirusForm::AffordRentMortgageBillsController < ApplicationController
  before_action :check_filter_question_answered

  def submit
    @form_responses = {
      afford_rent_mortgage_bills: strip_tags(params[:afford_rent_mortgage_bills]).presence,
    }

    invalid_fields = validate_radio_field(
      controller_name,
      group,
      radio: @form_responses[:afford_rent_mortgage_bills],
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
    session[:afford_rent_mortgage_bills] = @form_responses[:afford_rent_mortgage_bills]
  end

  def group
    "paying_bills"
  end

  def previous_path
    previous_question(controller_name)
  end
end
