# frozen_string_literal: true

require "csv"

class CoronavirusForm::DataExportResultsLinksController < ApplicationController
  if ENV.key?("DATA_EXPORT_BASIC_AUTH_USERNAME") && ENV.key?("DATA_EXPORT_BASIC_AUTH_PASSWORD")
    http_basic_authenticate_with(
      name: ENV.fetch("DATA_EXPORT_BASIC_AUTH_USERNAME"),
      password: ENV.fetch("DATA_EXPORT_BASIC_AUTH_PASSWORD"),
    )
  end

  def show
    respond_to do |format|
      format.html
      format.csv do
        render csv: ContentExporter.generate_results_link_csv
      end
    end
  end
end
