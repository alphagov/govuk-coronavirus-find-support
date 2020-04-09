module QuestionsHelper
  RESULTS_PAGE = "results".freeze
  FILTER_QUESTION = "need_help_with".freeze

  def determine_user_questions(groups)
    if groups.empty?
      I18n.t("coronavirus_form.groups").map { |_, group| group[:questions].keys if group[:title] }.compact.flatten
    else
      questions_to_ask = groups.map do |group|
        I18n.t("coronavirus_form.groups.#{group}.questions").stringify_keys.keys
      end
      questions_to_ask.flatten.compact
    end
  end

  def next_question(current_question)
    current_question_index = questions_to_ask.index(current_question)
    if current_question_index.nil?
      questions_to_ask.first
    elsif current_question_index == (questions_to_ask.length - 1)
      RESULTS_PAGE
    else
      questions_to_ask[current_question_index + 1]
    end
  end

  def previous_question(current_question)
    current_question_index = questions_to_ask.index(current_question)
    if current_question_index.zero?
      FILTER_QUESTION
    else
      questions_to_ask[current_question_index + -1]
    end
  end

  def questions_to_ask
    session[:questions_to_ask]
  end
end
