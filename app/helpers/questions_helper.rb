module QuestionsHelper
  FINAL_QUESTION = "able_to_leave".freeze
  FILTER_QUESTION = "need_help_with".freeze

  def determine_user_questions(groups)
    if groups.empty?
      all_questions
    else
      questions_to_ask = groups.map do |group|
        I18n.t("coronavirus_form.groups.#{group}.questions").stringify_keys.keys
      end
      questions_to_ask.flatten.compact
    end
  end

  def next_question(current_question)
    return first_question if current_question == FILTER_QUESTION
    return FINAL_QUESTION if current_question == last_question

    current_question_index = questions_to_ask.index(current_question)
    questions_to_ask[current_question_index + 1]
  end

  def previous_question(current_question)
    return last_question if current_question == FINAL_QUESTION
    return FILTER_QUESTION if current_question == first_question

    current_question_index = questions_to_ask.index(current_question)
    questions_to_ask[current_question_index + -1]
  end

  def questions_to_ask
    session_questions & all_questions
  end

  def session_questions
    session[:questions_to_ask]
  end

  def first_question
    questions_to_ask.first
  end

  def last_question
    questions_to_ask.last
  end

  def first_question_seen?
    session[:urgent_medical_help].present?
  end

  def last_question_seen?
    session[FINAL_QUESTION.to_sym].present?
  end

  def all_questions
    I18n.t("coronavirus_form.groups").map { |_, group| group[:questions].keys if group[:title] }.compact.flatten.map(&:to_s)
  end

  def remove_questions(questions)
    questions_to_ask - questions
  end
end
