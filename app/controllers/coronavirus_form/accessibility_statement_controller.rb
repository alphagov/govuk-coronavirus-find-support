# frozen_string_literal: true

class CoronavirusForm::AccessibilityStatementController < ApplicationController
  def show
    @previous_page = return_path
    super
  end

private

  def return_path
    request.referer.presence ? first_question_path : request.referer
  end
end
