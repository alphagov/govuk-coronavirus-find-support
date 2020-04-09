# frozen_string_literal: true

class CoronavirusForm::ResultsController < ApplicationController
  before_action :check_filter_question_answered
end
