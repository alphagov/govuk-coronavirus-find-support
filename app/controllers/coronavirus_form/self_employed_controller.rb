# frozen_string_literal: true

class CoronavirusForm::SelfEmployedController < ApplicationController
  before_action :check_filter_question_answered
  before_action :check_current_question_selected

  def submit
    @form_responses = {
      self_employed: strip_tags(params[:self_employed]).presence,
    }

    invalid_fields = validate_radio_field(
      controller_name,
      group,
      radio: @form_responses[:self_employed],
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)
      render controller_path
    else
      update_session_store
      update_questions_to_ask
      redirect_to polymorphic_url(next_question(controller_name))
    end
  end

private

  def update_questions_to_ask
    session[:questions_to_ask] = if I18n.t("coronavirus_form.groups.being_unemployed.questions.self_employed.skip_next_question_options").include? @form_responses[:self_employed]
                                   remove_questions(%w[have_you_been_made_unemployed])
                                 else
                                   add_questions(%w[have_you_been_made_unemployed], controller_name)
                                 end
  end

  def update_session_store
    session[:self_employed] = @form_responses[:self_employed]
  end

  def group
    "being_unemployed"
  end

  def previous_path
    polymorphic_path(previous_question(controller_name))
  end
end
