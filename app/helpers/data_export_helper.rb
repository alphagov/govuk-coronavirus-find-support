module DataExportHelper
  def all_usage_statistics(start_date, end_date)
    usage_statistics(start_date, end_date).merge!(checkbox_usage_statistics(start_date, end_date))
  end

  def usage_statistics(start_date, end_date)
    questions = I18n.t("coronavirus_form.groups").map { |_, v| v[:questions] }.reduce(:merge)

    start_date = Date.parse(sanitize(start_date)).beginning_of_day if start_date
    end_date = Date.parse(sanitize(end_date)).end_of_day if end_date

    results = {}
    questions.each_key do |question|
      question_text = questions.dig(question, :title)
      counts = FormResponse
        .tap { |q| q.where(created_at: start_date..end_date) if start_date && end_date }
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

  def checkbox_usage_statistics(start_date, end_date)
    start_date = Date.parse(sanitize(start_date)).beginning_of_day if start_date
    end_date = Date.parse(sanitize(end_date)).end_of_day if end_date

    results = {}

    checkbox_questions.each do |question_key, question_text|
      question_results = FormResponse.select do |form_responses|
        if form_responses[:form_response]["need_help_with"]
          if start_date && end_date
            form_responses[:created_at].between?(start_date, end_date) && form_responses[:form_response]["need_help_with"].include?(question_text)
          else
            form_responses[:form_response]["need_help_with"].include?(question_text)
          end
        end
      end

      unless question_results.empty?
        counts = { "Need help with: #{question_text}" => [{
          date: question_results.first.created_at,
          response: question_key,
          count: question_results.count,
        }] }

        results.merge!(counts)
      end
    end

    results
  end
end
