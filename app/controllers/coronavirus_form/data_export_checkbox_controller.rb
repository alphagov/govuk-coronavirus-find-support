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

  def usage_statistics(start_date, end_date)
    service_start_date = Date.parse("2020-03-23").beginning_of_day
    start_date = start_date ? Date.parse(sanitize(start_date)).beginning_of_day : service_start_date
    end_date = end_date ? Date.parse(sanitize(end_date)).end_of_day : Time.zone.today.end_of_day

    results = {}
    counts = Hash.new(0)
    responses = FormResponse
                  .where(created_at: start_date..end_date)
                  .select(Arel.sql("created_at::date, form_response -> 'need_help_with'"))
                  .pluck(Arel.sql("created_at::date, form_response -> 'need_help_with'"))
                  .flat_map do |created_date, selected_options|
                    selected_options.map do |option|
                      [option, created_date.to_date]
                    end
                  end

    responses.each do |response|
      counts[response] += 1
    end

    counts.map do |count|
      result = {
        count.first.join(" ").to_s => [{
          response: count.first.first,
          date: count.first.second,
          count: count.second,
        }],
      }

      results.merge!(result)
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
