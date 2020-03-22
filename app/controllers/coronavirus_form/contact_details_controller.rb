# frozen_string_literal: true

class CoronavirusForm::ContactDetailsController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  include FieldValidationHelper

  def show
    render "coronavirus_form/#{PAGE}"
  end

  def submit
    contact_details = {
      phone_number_calls: sanitize(params[:phone_number_calls]).presence,
      phone_number_texts: sanitize(params[:phone_number_texts]).presence,
      email: sanitize(params[:email]).presence,
    }
    session[:contact_details] = contact_details

    invalid_fields = contact_details[:email] ? validate_email_address("email", contact_details[:email]) : []

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

  PAGE = "contact_details"
  NEXT_PAGE = "medical_conditions"

  def previous_path
    coronavirus_form_support_address_path
  end
end
