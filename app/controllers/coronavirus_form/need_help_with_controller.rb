# frozen_string_literal: true

class CoronavirusForm::NeedHelpWithController < ApplicationController
  def submit
    @form_responses = {
      need_help_with: Array(params[:need_help_with]).map { |item| strip_tags(item).presence }.compact,
    }

    invalid_fields = validate_checkbox_field(
      controller_name,
      values: @form_responses[:need_help_with],
      allowed_values: group_titles + extra_options,
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

  helper_method :items

  def items
    groups_items = all_groups.map do |key, group|
      next if group[:title].blank?

      {
        value: group[:title],
        label: group[:title],
        id: "option_#{key}",
        checked: @form_responses.fetch(controller_name.to_sym, []).include?(group[:title]),
      }
    end

    options = extra_options.map do |option|
      {
        value: option,
        label: option,
        id: "option_#{option.parameterize.underscore}",
        checked: @form_responses.fetch(controller_name.to_sym, []).include?(option),
      }
    end

    groups_items.compact + options.compact
  end

  def group_titles
    all_groups.map { |_, group| group[:title] }.compact
  end

  def all_groups
    @all_groups ||= I18n.t("coronavirus_form.groups")
  end

  def extra_options
    @extra_options ||= I18n.t("coronavirus_form.groups.#{group}.questions.#{controller_name}.options")
  end

  def update_session_store
    session[:need_help_with] = @form_responses[:need_help_with]

    groups_hash = all_groups.map { |key, group| { key => group[:title] } if group[:title] }.compact.reduce(:merge)

    selected_groups = @form_responses[:need_help_with].map do |item|
      groups_hash.key(item) if groups_hash.has_value?(item)
    end

    session[:selected_groups] = selected_groups.compact
  end

  def previous_path
    "/"
  end

  def group
    "filter_questions"
  end
end
