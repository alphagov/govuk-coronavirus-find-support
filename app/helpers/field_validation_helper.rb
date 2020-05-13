# frozen_string_literal: true

module FieldValidationHelper
  def validate_mandatory_text_fields(mandatory_fields, page)
    invalid_fields = []
    mandatory_fields.each do |field|
      next if session[field].present?

      invalid_fields << { field: field.to_s,
                          text: t(
                            "coronavirus_form.groups.#{group}.questions.#{page}.#{field}.custom_error",
                            default: t("coronavirus_form.errors.missing_mandatory_text_field", field: t("coronavirus_form.#{page}.#{field}.label")).humanize,
                          ) }
    end
    invalid_fields
  end

  def validate_radio_field(page, group, radio:, other: false)
    if radio.blank?
      return [{ field: page.to_s,
                text: t(
                  "coronavirus_form.groups.#{group}.questions.#{page}.custom_select_error",
                  default: t("coronavirus_form.errors.radio_field", field: t("coronavirus_form.groups.#{group}.questions.#{page}.title")).humanize,
                ) }]
    end

    if other != false && other.blank? && %w[Yes Other].include?(radio)
      return [{ field: page.to_s,
                text: t(
                  "coronavirus_form.groups.#{group}.questions.#{page}.custom_enter_error",
                  default: t("coronavirus_form.errors.missing_mandatory_text_field", field: t("coronavirus_form.groups.#{group}.questions.#{page}.title")).humanize,
                ) }]
    end

    []
  end

  def validate_checkbox_field(page, values:, allowed_values:)
    if values.blank? || values.empty?
      return [{ field: page.to_s,
                text: t(
                  "coronavirus_form.groups.#{group}.questions.#{page}.custom_select_error",
                  default: t("coronavirus_form.errors.checkbox_field", field: t("coronavirus_form.groups.#{group}.questions.#{page}.title")).humanize,
                ) }]
    end

    if (values - allowed_values).any?
      return [{ field: page.to_s,
                text: t(
                  "coronavirus_form.groups.#{group}.questions.#{page}.custom_select_error",
                  default: t("coronavirus_form.errors.missing_mandatory_text_field", field: t("coronavirus_form.groups.#{group}.questions.#{page}.title")).humanize,
                ) }]
    end

    []
  end
end
