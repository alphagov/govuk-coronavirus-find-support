module ResultsHelper
  def result_groups(session)
    groups = relevant_group_keys.index_with do |group_key|
      filtered_questions = filter_questions_by_session(group_key, session)
      unless filtered_questions.empty?
        {
          heading: I18n.t("coronavirus_form.groups.#{group_key}.title"),
          questions: filtered_questions,
        }
      end
    end
    groups.compact
  end

  def filter_questions_by_session(group_key, session)
    I18n.t("results_link.#{group_key}").each_with_object([]) do |question, array|
      if question[1][:show_options].include?(session[question[0]])
        array << I18n.t("results_link.#{group_key}.#{question[0]}")
      end
    end
  end

  def relevant_group_keys
    # If the user selects only "I’m not sure" from /need-help-with, their selected groups will
    # be blank, but they'll be asked all questions. In this case we should assume all groups are
    # potentially relevant. We can get all groups from the Locale file, but will need to exclude
    # :help and :filter_questions which are not really groups
    # empty.
    if selected_groups.blank?
      return I18n.t("coronavirus_form.groups").keys - %i[filter_questions help leave_home]
    end

    selected_groups # Otherwise we can use selected groups
  end

  def selected_groups
    session["selected_groups"]
  end

  def results_title(result_groups_session)
    if result_groups_session.empty?
      t("coronavirus_form.results.header.title_no_results")
    else
      t("coronavirus_form.results.header.title")
    end
  end
end
