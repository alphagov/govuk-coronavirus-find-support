# frozen_string_literal: true

class CoronavirusForm::AffordRentMortgageBillsController < ApplicationController
  def submit
    @form_responses = {
      afford_rent_mortgage_bills: strip_tags(params[:afford_rent_mortgage_bills]).presence,
    }

    invalid_fields = validate_radio_field(
      controller_name,
      "paying_bills",
      radio: @form_responses[:afford_rent_mortgage_bills],
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)
      render controller_path
    else
      update_session_store
      #redirect_to nil
    end
  end

private

  def update_session_store
    session[:afford_rent_mortgage_bills] = @form_responses[:afford_rent_mortgage_bills]
  end

  def previous_path; end
end
