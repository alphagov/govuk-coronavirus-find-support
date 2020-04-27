# frozen_string_literal: true

class CoronavirusForm::GetFoodController < ApplicationController
  before_action :check_first_question_answered
  before_action :check_current_question_selected

  def submit
    @form_responses = {
      get_food: strip_tags(params[:get_food]).presence,
    }

    invalid_fields = validate_radio_field(
      controller_name,
      group,
      radio: @form_responses[:get_food],
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
    session[:get_food] = @form_responses[:get_food]
  end

  def group
    "getting_food"
  end

  def previous_path
    polymorphic_path(previous_question(controller_name))
  end
end
