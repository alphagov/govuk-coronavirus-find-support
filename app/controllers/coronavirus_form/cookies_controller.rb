# frozen_string_literal: true

class CoronavirusForm::CookiesController < ApplicationController
  include SetPreviousPage

  def show
    set_previous_page
    super
  end
end
