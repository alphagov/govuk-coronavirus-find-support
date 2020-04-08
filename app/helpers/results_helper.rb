module ResultsHelper
  def result_groups(form_responses)
    form_responses
  end

  def no_results?(form_responses)
    result_groups(form_responses).empty?
  end

  private

end
