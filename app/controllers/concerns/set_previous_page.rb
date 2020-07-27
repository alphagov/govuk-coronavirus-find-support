module SetPreviousPage
  include ActionView::Helpers::UrlHelper

  def set_previous_page
    @previous_page = previous_page_from_referer
  end

  def previous_page_from_referer
    return first_question_path if request.referer.blank? || current_page?(request.referer)

    request.referer
  end
end
