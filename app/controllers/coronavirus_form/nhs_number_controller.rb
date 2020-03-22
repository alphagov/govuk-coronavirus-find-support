# frozen_string_literal: true

class CoronavirusForm::NhsNumberController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  include NhsNumberValidatorHelper
  include FieldValidationHelper

  def show
    session[:nhs_number] ||= {}
    render "coronavirus_form/#{PAGE}"
  end

  def submit
    session[:nhs_number] ||= {}
    session[:nhs_number] = sanitize(clean_nhs_number(params["nhs_number"])).presence

    invalid_fields = validate_fields(session[:nhs_number])

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)
      render "coronavirus_form/#{PAGE}", status: :unprocessable_entity
    elsif session["check_answers_seen"]
      redirect_to controller: "coronavirus_form/check_answers", action: "show"
    else
      redirect_to controller: "coronavirus_form/#{NEXT_PAGE}", action: "show"
    end
  end

private

  def clean_nhs_number(unclean_nhs_number)
    unclean_nhs_number&.gsub(" ", "")
  end

  def validate_fields(nhs_number)
    validation_response = validate_nhs_number_correctness(nhs_number)
    return [] if validation_response[:valid]

    puts validation_response.inspect

    [
      {
        field: "nhs_number",
        text: validation_response[:message],
      },
    ]
  end

  PAGE = "nhs_number"
  NEXT_PAGE = "check_answers" # TODO change to address

  def previous_path
    "/" # TODO
  end
end
