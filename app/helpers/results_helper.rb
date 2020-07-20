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
    group = I18n.t("results_link.#{group_key}").dup
    group.each_with_object([]) do |question, array|
      if question[1][:show_options].include?(session[question[0]])
        array << filter_results_by_multiple_questions(I18n.t("results_link.#{group_key}.#{question[0]}").dup)
      end
    end
  end

  def filter_results_by_multiple_questions(question_results)
    %i[items support_and_advice_items].each do |item_type|
      question_results[item_type] = filter_item_type_results_by_multiple_questions(item_type, question_results)
    end
    question_results
  end

  def relevant_group_keys
    # If the user selects only "I'm not sure" from /need-help-with, their selected groups will
    # be blank, but they'll be asked all questions. In this case we should assume all groups are
    # potentially relevant. We can get all groups from the Locale file, but will need to exclude
    # :help and :filter_questions which are not really groups
    # empty.
    if selected_groups.blank?
      return I18n.t("coronavirus_form.groups").keys - %i[filter_questions help location]
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

private

  def filter_item_type_results_by_multiple_questions(item_type, question_results)
    question_results[item_type] ||= []
    question_results[item_type].select do |item|
      show_to_nations_check(item)
    end
  end

  def show_to_nations_check(item)
    item[:show_to_nations].nil? || item[:show_to_nations].include?(session[:nation])
  end
end
