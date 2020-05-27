require "csv"

class CoronavirusForm::DataExportCheckboxController < ApplicationController
  if ENV.key?("DATA_EXPORT_BASIC_AUTH_USERNAME") && ENV.key?("DATA_EXPORT_BASIC_AUTH_PASSWORD")
    http_basic_authenticate_with(
      name: ENV.fetch("DATA_EXPORT_BASIC_AUTH_USERNAME"),
      password: ENV.fetch("DATA_EXPORT_BASIC_AUTH_PASSWORD"),
    )
  end

  def show
    respond_to do |format|
      format.html
      format.csv do
        render csv: produce_csv(usage_statistics(params[:start_date], params[:end_date])),
               filename: "data-export"
      end
    end
  end

  def checkbox_options
    options = I18n.t("coronavirus_form.groups")[:filter_questions][:questions][:need_help_with][:options]

    options.index_by do |_option|
      :need_help_with
    end
  end

  def checkbox_questions
    questions = I18n.t("coronavirus_form.groups").map { |key, group|
      { key => group[:title] } if group[:title]
    }
      .compact
      .reduce(:merge)

    questions.merge!(checkbox_options)
  end

  def usage_statistics(start_date, end_date)
    start_date = Date.parse(sanitize(start_date)).beginning_of_day if start_date
    end_date = Date.parse(sanitize(end_date)).end_of_day if end_date

    results = {}

    checkbox_questions.each do |_question_key, question_text|
      checkbox_responses = FormResponse.select do |form_responses|
        if form_responses[:form_response]["need_help_with"]
          if start_date && end_date
            form_responses[:created_at].between?(start_date, end_date) && form_responses[:form_response]["need_help_with"].include?(question_text)
          else
            form_responses[:form_response]["need_help_with"].include?(question_text)
          end
        end
      end

      next if checkbox_responses.empty?

      checkbox_responses.each do |response|
        counts = { "#{response.created_at.to_date} #{question_text}" => [{
          response: question_text,
          date: response.created_at.to_date,
          count: checkbox_responses.select { |responses| responses[:created_at].to_date == response.created_at.to_date && responses[:form_response]["need_help_with"].include?(question_text) }.count,
        }] }

        results.merge!(counts)
      end
    end

    results
  end

private

  def produce_csv(results)
    question = I18n.t("coronavirus_form.groups")[:filter_questions][:questions][:need_help_with][:title]
    csv_data = CSV.generate(col_sep: "|") do |csv|
      csv << %w[question answer date count]
      results.each do |_question, value|
        value.each do |k|
          csv << [
            question,
            k[:response],
            k[:date],
            k[:count],
          ]
        end
      end
    end

    csv_data
  end
end
