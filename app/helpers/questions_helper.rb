module QuestionsHelper
  RESULTS_PAGE = "results".freeze
  FILTER_QUESTION = "need_help_with".freeze

  def next_question(current_question)
    current_question_index = questions_to_ask.index(current_question)
    if current_question_index == (questions_to_ask.length - 1)
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

private

  def questions_to_ask
    session[:questions_to_ask]
  end
end
