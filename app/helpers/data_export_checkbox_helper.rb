module DataExportCheckboxHelper
  def usage_statistics(start_date, end_date)
    start_date = start_date ? Date.parse(sanitize(start_date)).beginning_of_day : service_start_date
    end_date = end_date ? Date.parse(sanitize(end_date)).end_of_day : nil

    results = {}
    counts = Hash.new(0)

    responses(start_date, end_date).each do |response|
      counts[response] += 1
    end

    counts.each do |(option_text, created_date), count|
      results.merge!(result(option_text, created_date, count))
    end

    results
  end

private

  def service_start_date
    Date.parse("2020-03-23").beginning_of_day
  end

  def result(option_text, created_date, count)
    {
      [option_text, created_date].join(" ").to_s => [{
        response: option_text,
        date: created_date,
        count: count,
      }],
    }
  end

  def responses(start_date, end_date)
    FormResponse
    .where(created_at: start_date..end_date)
    .pluck(Arel.sql("created_at::date, form_response -> 'need_help_with'"))
    .flat_map do |created_date, selected_options|
      selected_options.map do |option|
        [option, created_date.to_date]
      end
    end
  end
end
