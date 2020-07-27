# frozen_string_literal: true

class CoronavirusForm::AccessibilityStatementController < ApplicationController
  include SetPreviousPage

  def show
    set_previous_page
    super
  end
end
