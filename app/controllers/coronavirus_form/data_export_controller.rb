# frozen_string_literal: true

require "csv"

class CoronavirusForm::DataExportController < ApplicationController
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

  def usage_statistics(start_date, end_date)
    questions = I18n.t("coronavirus_form.groups").map { |_, v| v[:questions] }.reduce(:merge)

    start_date = Date.parse(sanitize(start_date)).beginning_of_day if start_date
    end_date = Date.parse(sanitize(end_date)).end_of_day if end_date

    results = {}
    questions.each_key do |question|
      question_text = questions.dig(question, :title)
      responses = if start_date && end_date
                    FormResponse.where(created_at: start_date..end_date)
                  else
                    FormResponse.all
                  end

      counts = responses
        .select(Arel.sql("created_at::date, form_response -> '#{question}', COUNT(*)"))
        .group(Arel.sql("created_at::date, form_response -> '#{question}'"))
        .pluck(Arel.sql("created_at::date, form_response -> '#{question}', COUNT(*)"))
        .reject { |form_responses| form_responses.second.nil? }
        .map do |form_responses|
          {
            date: form_responses.first.strftime("%Y-%m-%d"),
            response: Array(form_responses.second).join(";"),
            count: form_responses.third,
          }
        end
      results[question_text] = counts if counts.present?
    end
    results
  end

private

  def produce_csv(results)
    csv_data = CSV.generate(col_sep: "|") do |csv|
      csv << %w[question answer date count]
      results.each do |question, value|
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
