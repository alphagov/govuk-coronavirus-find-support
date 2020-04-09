# frozen_string_literal: true

class CoronavirusForm::SessionController < ApplicationController
  skip_before_action :check_first_question

  def delete
    reset_session
    redirect_to "/"
  end
end
