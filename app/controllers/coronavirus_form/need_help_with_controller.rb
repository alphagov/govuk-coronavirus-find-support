# frozen_string_literal: true

class CoronavirusForm::NeedHelpWithController < ApplicationController
  def submit
    @form_responses = {
      need_help_with: Array(params[:need_help_with]).map { |item| strip_tags(item).presence }.compact,
    }

    invalid_fields = validate_checkbox_field(
      controller_name,
      values: @form_responses[:need_help_with],
      allowed_values: I18n.t("coronavirus_form.groups.#{group}.questions.#{controller_name}.options"),
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)
      render controller_path
    else
      update_session_store
      # redirect_to nil
    end
  end

private

  def update_session_store
    session[:need_help_with] = @form_responses[:need_help_with]

    selected_groups = @form_responses[:need_help_with].map do|item|
      key = item.parameterize.underscore.to_sym
      [key, true]
    end

    session[:selected_groups] = Hash[selected_groups]
  end

  def previous_path
    "/"
  end

  def group
    "filter_questions"
  end
end
