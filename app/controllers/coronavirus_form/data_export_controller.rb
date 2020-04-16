# frozen_string_literal: true

require "csv"

class CoronavirusForm::DataExportController < ApplicationController
  def show
    respond_to do |format|
      format.html { render controller_path }
      format.csv { render csv: produce_csv(usage_statistics(params[:start_date], params[:end_date])), filename: "data-export" }
    end
  end

  def usage_statistics(start_date, end_date)
    questions = I18n.t("coronavirus_form.groups").map { |_, v| v[:questions] }.reduce(:merge)

    start_date = Date.parse(sanitize(start_date)).beginning_of_day
    end_date = Date.parse(sanitize(end_date)).end_of_day

    results = {}
    questions.each_key do |question|
      question_text = questions.dig(question, :title)
      counts = FormResponse
        .where(created_at: start_date..end_date)
        .select(Arel.sql(%{created_at::date, form_response -> '#{question}', COUNT(*)}))
        .group(Arel.sql(%{created_at::date, form_response -> '#{question}'}))
        .pluck(Arel.sql(%{created_at::date, form_response -> '#{question}', COUNT(*)}))
        .reject { |form_responses| form_responses[1].nil? }
        .map do |form_responses|
          {
            date: form_responses[0].strftime("%Y-%m-%d"),
            response: Array(form_responses[1]).join(";"),
            count: form_responses[2],
          }
        end
      results[question_text] = counts if counts.present?
    end
    results
  end

private

  def produce_csv(results)
    csv_data = CSV.generate do |csv|
      csv << %w(question answer date count)
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
