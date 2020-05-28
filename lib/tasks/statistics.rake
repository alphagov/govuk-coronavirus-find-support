namespace :statistics do
  desc "Get information on all form responses for a specified day, e.g. rake statistics:form_responses[2020-04-13]"
  task :form_responses, [:date] => [:environment] do |_, args|
    # Counts responses for each question (as defined in locales) on a given day
    # and produces output in the following format (fictional data used as an
    # example):
    #
    # What do you need to find help with because of coronavirus?
    # - ["Feeling unsafe"]: 1
    # - ["Feeling unsafe", "Paying bills"]: 3
    # - ["Getting food"]: 2
    # - ["Going in to work"]: 1
    # - ["Having somewhere to live"]: 1
    # - ["Paying bills"]: 3
    # - ["Paying bills", "I'm not sure"]: 1
    # - ["Paying bills", "Mental health and wellbeing"]: 1
    #
    # Do you need urgent medical help?
    #  - No: 13
    #
    # Do you feel safe where you live?
    #  - No: 2
    #  - Yes: 1
    #  - Yes, but I'm concerned about the safety of someone else: 1

    args.with_defaults(date: Date.yesterday.to_s)

    responses = FormResponse.where(created_at: Date.parse(args.date).all_day)

    questions = I18n.t("coronavirus_form.groups").map { |_, v| v[:questions] }.reduce(:merge)

    questions.each_key do |question|
      question_text = questions.dig(question, :title)
      response_count = responses
        .group("form_response -> '#{question}'")
        .count
        .reject { |k, _| k.nil? }
        .sort
        .map { |k, v| " - #{k}: #{v}" }
        .join("\n")
      puts "#{question_text}\n#{response_count}\n\n"
    end
  end
end
