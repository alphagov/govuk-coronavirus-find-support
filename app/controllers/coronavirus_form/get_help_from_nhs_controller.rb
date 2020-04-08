# frozen_string_literal: true

class CoronavirusForm::GetHelpFromNhsController < ApplicationController
  skip_before_action :check_first_question
end
