require "csv"

class CoronavirusForm::DataExportCheckboxController < ApplicationController
  include DataExportCheckboxHelper

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
