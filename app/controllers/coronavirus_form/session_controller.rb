# frozen_string_literal: true

class CoronavirusForm::SessionController < ApplicationController
  def delete
    reset_session
    redirect_to "/"
  end
end
