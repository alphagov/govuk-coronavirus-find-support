# frozen_string_literal: true

class CoronavirusForm::ContactDetailsController < ApplicationController
  def show
    session[:contact_details] ||= {}
    render "coronavirus_form/#{PAGE}"
  end

  def submit
    session[:contact_details] ||= {}
    session[:contact_details][:phone_number_calls] = sanitize(params[:phone_number_calls]&.strip).presence
    session[:contact_details][:phone_number_texts] = sanitize(params[:phone_number_texts]&.strip).presence
    session[:contact_details][:email] = sanitize(params[:email]&.strip).presence

    invalid_fields = if session[:contact_details].dig(:email)
                       validate_email_address("email", session[:contact_details].dig(:email))
                     else
                       []
      end

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)
      render "coronavirus_form/#{PAGE}", status: :unprocessable_entity
    elsif session[:check_answers_seen]
      redirect_to controller: "coronavirus_form/check_answers", action: "show"
    else
      redirect_to controller: "coronavirus_form/#{NEXT_PAGE}", action: "show"
    end
  end

private

  PAGE = "contact_details"
  NEXT_PAGE = "medical_conditions"

  def previous_path
    support_address_path
  end
end
