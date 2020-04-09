# frozen_string_literal: true

class CoronavirusForm::GetHelpFromNhsController < ApplicationController
  def show
    @previous_page = previous_path
    super
  end

private

  def previous_path
    urgent_medical_help_path
  end
end
