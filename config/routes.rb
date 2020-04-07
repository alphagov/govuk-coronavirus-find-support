# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/healthcheck", to: proc { [200, {}, %w[OK]] }

  get "/", to: redirect("https://www.gov.uk/")

  scope module: "coronavirus_form" do
    get "/privacy", to: "privacy#show"
    get "/accessibility-statement", to: "accessibility_statement#show"

    get "/still-working", to: "still_working#show"
    post "/still-working", to: "still_working#submit"

    get "/session-expired", to: "session_expired#show"
  end

  mount GovukPublishingComponents::Engine, at: "/component-guide"
end
