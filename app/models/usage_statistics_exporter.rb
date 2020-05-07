require "csv"

class UsageStatisticsExporter
  def self.results(start_date, end_date)
    questions = I18n.t("coronavirus_form.groups").map { |_, v| v[:questions] }.reduce(:merge)

    start_date = Date.parse(ActionController::Base.helpers.sanitize(start_date)).beginning_of_day
    end_date = Date.parse(ActionController::Base.helpers.sanitize(end_date)).end_of_day

    results = {}
    questions.each_key do |question|
      question_text = questions.dig(question, :title)
      counts = FormResponse
        .where(created_at: start_date..end_date)
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

  def self.produce_csv(results)
    csv_data = CSV.generate(col_sep: "|") do |csv|
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
